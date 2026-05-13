// ============================================================
// Storage/GoalStorage.swift
// Ruta: DiaryApp/Storage/GoalStorage.swift
//
// Persiste el estado completo de las metas del usuario en disco.
// Guarda dos valores en archivos JSON separados:
//   - El arreglo de metas activas (goals_active.json)
//   - El número de fase actual (goals_phase.json)
//
// PATRÓN: Idéntico a DiaryStorage para mantener consistencia.
// Usa Codable + JSONEncoder/Decoder con escritura atómica.
//
// EXTENSIBILIDAD:
// - Para guardar el historial de fases completadas (útil para
//   estadísticas), agrega un tercer archivo goals_history.json
//   y los métodos saveHistory() / loadHistory().
// - Para migrar a CoreData en el futuro, implementa los mismos
//   métodos públicos en una clase GoalStorageCoreData y
//   reemplaza la referencia en GoalsViewModel sin tocar las vistas.
// ============================================================

import Foundation

class GoalStorage {

    // Singleton: una sola instancia en toda la app.
    static let shared = GoalStorage()
    private init() {}

    // ── Nombres de archivo ───────────────────────────────────
    // ⚠️ No cambiar sin estrategia de migración.
    private let activeGoalsFile = "goals_active.json"
    private let currentPhaseFile = "goals_phase.json"

    // MARK: - URLs de archivos

    /// URL base del directorio Documents de la app.
    private var documentsURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    /// URL del archivo JSON de metas activas.
    private var activeGoalsURL: URL? {
        documentsURL?.appendingPathComponent(activeGoalsFile)
    }

    /// URL del archivo JSON de la fase actual.
    private var currentPhaseURL: URL? {
        documentsURL?.appendingPathComponent(currentPhaseFile)
    }

    // ============================================================
    // MARK: - Metas activas: cargar y guardar
    // ============================================================

    /// Carga el arreglo de metas activas desde disco.
    /// Devuelve [] si el archivo no existe (primera vez que corre la app).
    func loadActiveGoals() -> [Goal] {
        // Intenta leer el archivo. Si no existe, devuelve vacío sin error.
        guard
            let url  = activeGoalsURL,
            let data = try? Data(contentsOf: url)
        else {
            return []  // Primera ejecución: sin datos previos
        }

        do {
            let decoder = JSONDecoder()
            // Usamos ISO8601 para fechas compatibles y legibles.
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Goal].self, from: data)
        } catch {
            // Si hay corrupción de datos, log en debug y devuelve vacío.
            // EXTENSIBILIDAD: Aquí podrías intentar una migración antes
            // de devolver vacío, si cambiaste el modelo de Goal.
            print("⚠️ GoalStorage.loadActiveGoals – Error: \(error)")
            return []
        }
    }

    /// Guarda el arreglo completo de metas activas en disco.
    /// Usa escritura atómica para evitar corrupción si la app se cierra.
    func saveActiveGoals(_ goals: [Goal]) {
        guard let url = activeGoalsURL else { return }

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            // prettyPrinted: facilita la depuración manual del JSON.
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(goals)
            // .atomicWrite garantiza que el archivo no quede a medias.
            try data.write(to: url, options: .atomicWrite)
        } catch {
            print("⚠️ GoalStorage.saveActiveGoals – Error: \(error)")
        }
    }

    // ============================================================
    // MARK: - Fase actual: cargar y guardar
    // ============================================================

    /// Carga el número de fase actual desde disco.
    /// Devuelve 1 si no hay datos previos (siempre empieza en Fase 1).
    func loadCurrentPhase() -> Int {
        guard
            let url  = currentPhaseURL,
            let data = try? Data(contentsOf: url)
        else {
            return 1  // Primera ejecución: Fase 1
        }

        // La fase es un simple Int guardado como JSON.
        return (try? JSONDecoder().decode(Int.self, from: data)) ?? 1
    }

    /// Guarda el número de fase actual en disco.
    func saveCurrentPhase(_ phase: Int) {
        guard let url = currentPhaseURL else { return }
        let data = (try? JSONEncoder().encode(phase)) ?? Data()
        try? data.write(to: url, options: .atomicWrite)
    }

    // ============================================================
    // MARK: - Utilidades para módulos futuros
    // ============================================================

    /// Elimina todos los datos de metas (útil para reset en desarrollo
    /// o para una futura función "Reiniciar metas" en Configuración).
    ///
    /// EXTENSIBILIDAD (Módulo de Configuración):
    ///   Llama a este método desde una pantalla de ajustes con
    ///   confirmación del usuario antes de borrar.
    func deleteAllGoalData() {
        if let url = activeGoalsURL  { try? FileManager.default.removeItem(at: url) }
        if let url = currentPhaseURL { try? FileManager.default.removeItem(at: url) }
    }

    /// Devuelve las metas completadas para análisis estadístico.
    ///
    /// EXTENSIBILIDAD (Módulo de Estadísticas / Bienestar):
    ///   Usa este método para mostrar cuántas metas ha completado
    ///   el usuario en total, y en qué fechas.
    func loadCompletedGoals() -> [Goal] {
        loadActiveGoals().filter { $0.isCompleted }
    }
}
