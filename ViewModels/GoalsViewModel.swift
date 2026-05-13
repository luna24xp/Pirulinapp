// ============================================================
// ViewModels/GoalsViewModel.swift
// Ruta: DiaryApp/ViewModels/GoalsViewModel.swift
//
// ViewModel de metas. Contiene toda la lógica de negocio:
//   • Inicializar metas de Fase 1 en el primer arranque
//   • Marcar / desmarcar metas como completadas
//   • Detectar cuando se completan las 5 activas y avanzar de fase
//   • Construir el conjunto de 5 metas para cada nueva fase
//     (3 predefinidas + 2 slots rellenos automáticamente o por usuario)
//   • Permitir que el usuario reemplace un slot con una meta propia
//   • Persistir todo en GoalStorage
//
// EXTENSIBILIDAD:
// - Para agregar notificaciones de "¡Completaste una fase!",
//   usa UNUserNotificationCenter en `advanceToNextPhase()`.
// - Para conectar metas con el DiaryViewModel (ej. "esta meta
//   se activa cuando escribes X veces"), agrega una referencia
//   @Published a DiaryViewModel y observa sus cambios aquí.
// - Para agregar logros/badges, crea un array `unlockedBadges`
//   y actualízalo en `checkPhaseCompletion()`.
// ============================================================

import SwiftUI
import Combine

class GoalsViewModel: ObservableObject {

    // ============================================================
    // MARK: - Estado publicado (la UI reacciona a estos cambios)
    // ============================================================

    /// Las 5 metas actualmente activas.
    /// La UI observa este arreglo: cualquier cambio dispara un redibujado.
    @Published var activeGoals: [Goal] = []

    /// Fase en la que está el usuario actualmente (comienza en 1).
    @Published var currentPhase: Int = 1

    /// true cuando todas las metas activas están completadas y la
    /// app está construyendo la nueva fase. Sirve para mostrar un
    /// loader o mensaje de "¡Fase completada!" en la UI.
    @Published var isTransitioningPhase: Bool = false

    // ============================================================
    // MARK: - Constantes configurables
    // ============================================================

    /// Número de metas activas en todo momento.
    /// EXTENSIBILIDAD: Cambia este valor si quieres más de 5 metas.
    /// Asegúrate de ajustar GoalSets.initialGoals al mismo número.
    private let goalsPerPhase: Int = 5

    /// Número de metas predefinidas que el sistema da en Fase 2+.
    /// El resto (goalsPerPhase - predefinedInPhase2) son slots personalizables.
    private let predefinedInPhase2: Int = 3

    /// Número de slots personalizables en Fase 2+ (goalsPerPhase - predefinedInPhase2).
    /// Este valor se calcula, no se edita directamente.
    private var customSlotsInPhase2: Int { goalsPerPhase - predefinedInPhase2 }

    // ============================================================
    // MARK: - Inicializador
    // ============================================================

    init() {
        // Validación en debug: verifica que GoalSets tiene el número correcto.
        // Si esta aserción falla, el developer sabe qué archivo corregir.
        assert(
            GoalSets.initialGoals.count == goalsPerPhase,
            "⚠️ GoalSets.initialGoals debe tener exactamente \(goalsPerPhase) elementos."
        )
        assert(
            GoalSets.phase2Goals.count == predefinedInPhase2,
            "⚠️ GoalSets.phase2Goals debe tener exactamente \(predefinedInPhase2) elementos."
        )
        assert(
            GoalSets.fillerGoals.count >= customSlotsInPhase2,
            "⚠️ GoalSets.fillerGoals debe tener al menos \(customSlotsInPhase2) elementos."
        )

        loadState()
    }

    // ============================================================
    // MARK: - Carga inicial
    // ============================================================

    /// Carga el estado desde disco o inicializa Fase 1 si es el primer arranque.
    private func loadState() {
        currentPhase = GoalStorage.shared.loadCurrentPhase()
        let saved    = GoalStorage.shared.loadActiveGoals()

        if saved.isEmpty {
            // Primera vez: construir y guardar las 5 metas iniciales.
            buildGoals(forPhase: 1)
        } else {
            // Sesiones posteriores: restaurar el estado guardado.
            activeGoals = saved
        }
    }

    // ============================================================
    // MARK: - Construir metas para una fase
    // ============================================================

    /// Construye el arreglo de 5 metas activas para la fase indicada.
    /// Esta función es el corazón del módulo de fases.
    ///
    /// - Parameter phase: Número de fase (1-based).
    ///
    /// EXTENSIBILIDAD: Para agregar Fase 3, agrega `case 3:` aquí
    /// siguiendo exactamente el mismo patrón del `case 2:`.
    private func buildGoals(forPhase phase: Int) {
        currentPhase = phase
        var goals: [Goal] = []

        switch phase {

        // ── FASE 1: 5 metas predefinidas fijas ──────────────────
        // Todas vienen de GoalSets.initialGoals.
        // Ninguna es personalizable.
        case 1:
            goals = GoalSets.initialGoals.enumerated().map { (index, def) in
                Goal(
                    phase:        1,
                    displayOrder: index,
                    title:        def.title,
                    description:  def.description,
                    goalType:     .predefined,
                    isCustomizable: false  // Las de Fase 1 nunca son reemplazables
                )
            }

        // ── FASE 2 (y fases ≥ 2): 3 predefinidas + 2 slots ─────
        // Primero se agregan las predefinidas de esta fase,
        // luego se añaden fillers en los slots restantes.
        // Los fillers son customizables (el usuario puede reemplazarlos).
        default:
            // Paso 1: Obtener las 3 metas predefinidas de la fase.
            // Para fases > 2 sin datos específicos, reutiliza phase2Goals
            // como respaldo (patrón extensible: agrega GoalSets.phase3Goals
            // en GoalSets.swift y un `case 3:` aquí para diferenciarlas).
            let predefined = (phase == 2)
                ? GoalSets.phase2Goals
                : GoalSets.phase2Goals  // ← Reemplaza por GoalSets.phase3Goals cuando exista

            // Convierte definiciones de texto en objetos Goal completos
            for (index, def) in predefined.enumerated() {
                let goal = Goal(
                    phase:          phase,
                    displayOrder:   index,
                    title:          def.title,
                    description:    def.description,
                    goalType:       .predefined,
                    isCustomizable: false  // Las predefinidas de cada fase no son reemplazables
                )
                goals.append(goal)
            }

            // Paso 2: Llenar los slots restantes con metas de relleno.
            // customSlotsInPhase2 = 2 por defecto.
            // Se toman del pool GoalSets.fillerGoals en orden.
            let slotsNeeded = goalsPerPhase - predefined.count

            // Elige qué fillers usar para esta fase específica.
            // En fases futuras podrías rotar o usar índices distintos.
            let fillerPool  = GoalSets.fillerGoals
            let fillers     = Array(fillerPool.prefix(slotsNeeded))

            for (slotIndex, def) in fillers.enumerated() {
                let goal = Goal(
                    phase:          phase,
                    displayOrder:   predefined.count + slotIndex,
                    title:          def.title,
                    description:    def.description,
                    goalType:       .filler,
                    isCustomizable: true  // ← El usuario PUEDE reemplazar estos
                )
                goals.append(goal)
            }
        }

        // Asignar y persistir las nuevas metas
        activeGoals = goals
        saveState()
    }

    // ============================================================
    // MARK: - Completar / descompletar metas
    // ============================================================

    /// Alterna el estado de completado de una meta.
    /// Si al completarla todas las demás también están completas,
    /// inicia la transición a la siguiente fase.
    ///
    /// - Parameter goal: La meta que el usuario tocó (checkbox).
    func toggleGoalCompletion(_ goal: Goal) {
        // Busca el índice de la meta en el arreglo activo
        guard let idx = activeGoals.firstIndex(where: { $0.id == goal.id })
        else { return }

        // Alterna el estado
        activeGoals[idx].isCompleted.toggle()

        if activeGoals[idx].isCompleted {
            // Meta completada: registra la fecha
            activeGoals[idx].completedDate = Date()
        } else {
            // Meta descompletada: borra la fecha
            activeGoals[idx].completedDate = nil
        }

        saveState()

        // Verifica si todas las metas activas están completadas
        checkPhaseCompletion()
    }

    // ============================================================
    // MARK: - Detección y avance de fase
    // ============================================================

    /// Revisa si todas las metas activas están completas.
    /// Si es así, espera brevemente y avanza a la siguiente fase.
    private func checkPhaseCompletion() {
        // allSatisfy devuelve true solo si TODAS las metas están completadas
        let allDone = activeGoals.allSatisfy { $0.isCompleted }
        guard allDone else { return }

        // Un pequeño delay permite que la UI muestre el último checkbox
        // completado antes de que desaparezca la lista actual.
        // EXTENSIBILIDAD: Muestra aquí una animación de "¡Fase completada!"
        // usando el flag `isTransitioningPhase` en la vista.
        isTransitioningPhase = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self = self else { return }
            self.advanceToNextPhase()
            self.isTransitioningPhase = false
        }
    }

    /// Avanza al número de fase siguiente y construye las nuevas metas.
    private func advanceToNextPhase() {
        let nextPhase = currentPhase + 1
        buildGoals(forPhase: nextPhase)
        // EXTENSIBILIDAD: Aquí puedes:
        //   - Programar una notificación local de felicitación
        //   - Agregar un logro al array `unlockedBadges`
        //   - Llamar a un API para registrar el progreso
    }

    // ============================================================
    // MARK: - Personalización de metas (reemplazar fillers)
    // ============================================================

    /// Reemplaza una meta de tipo `.filler` con una meta creada por el usuario.
    ///
    /// - Parameters:
    ///   - goalId:      ID de la meta filler a reemplazar.
    ///   - title:       Título de la meta personalizada del usuario.
    ///   - description: Descripción de la meta personalizada.
    ///
    /// La lógica de cuántos slots quedan es automática:
    ///   - Si el usuario reemplaza los 2 fillers → quedan 0 fillers, 2 custom.
    ///   - Si reemplaza 1 → queda 1 filler, 1 custom.
    ///   - Si no reemplaza ninguno → quedan 2 fillers, 0 custom.
    func replaceFillerWithCustomGoal(goalId: UUID, title: String, description: String) {
        guard
            let idx = activeGoals.firstIndex(where: { $0.id == goalId }),
            activeGoals[idx].isCustomizable,           // Solo fillers reemplazables
            activeGoals[idx].goalType == .filler       // Confirma que es un filler
        else { return }

        // Construye la nueva meta custom manteniendo el mismo orden visual
        let customGoal = Goal(
            phase:          activeGoals[idx].phase,
            displayOrder:   activeGoals[idx].displayOrder,
            title:          title,
            description:    description,
            goalType:       .custom,
            isCustomizable: false  // Una vez personalizada, ya no se puede volver a cambiar
                                   // EXTENSIBILIDAD: pon `true` si quieres permitir edición posterior
        )

        activeGoals[idx] = customGoal
        saveState()
    }

    // ============================================================
    // MARK: - Propiedades calculadas para la UI
    // ============================================================

    /// Número de metas completadas actualmente.
    var completedCount: Int {
        activeGoals.filter { $0.isCompleted }.count
    }

    /// Progreso de 0.0 a 1.0 para la barra de progreso.
    var progressFraction: Double {
        guard !activeGoals.isEmpty else { return 0 }
        return Double(completedCount) / Double(activeGoals.count)
    }

    /// Número de slots que aún pueden ser personalizados por el usuario.
    var remainingCustomSlots: Int {
        activeGoals.filter { $0.goalType == .filler && $0.isCustomizable }.count
    }

    /// true si existe al menos un slot personalizable disponible.
    var hasCustomizableSlots: Bool {
        remainingCustomSlots > 0
    }

    // ============================================================
    // MARK: - Persistencia
    // ============================================================

    /// Guarda el estado actual en disco.
    /// Se llama después de cualquier cambio de estado.
    private func saveState() {
        GoalStorage.shared.saveActiveGoals(activeGoals)
        GoalStorage.shared.saveCurrentPhase(currentPhase)
    }

    // ============================================================
    // MARK: - Herramientas de desarrollo / Configuración
    // ============================================================

    /// Resetea TODAS las metas y vuelve a Fase 1.
    /// Para activar: llámalo desde una pantalla de Configuración
    /// con confirmación del usuario.
    ///
    /// ⚠️ DESTRUCTIVO: borra el progreso del usuario.
    func resetAllGoals() {
        GoalStorage.shared.deleteAllGoalData()
        buildGoals(forPhase: 1)
    }
}
