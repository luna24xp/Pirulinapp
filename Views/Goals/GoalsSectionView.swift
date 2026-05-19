// ============================================================
// Views/Goals/GoalsSectionView.swift
// Ruta: DiaryApp/Views/Goals/GoalsSectionView.swift
//
// Recuadro de metas que se muestra al final de JournalListView.
// Contiene tres secciones visuales:
//   1. Encabezado: título, fase, contador y barra de progreso
//   2. Lista de metas: hasta 5 filas con checkbox
//   3. Footer: mensaje de transición de fase o de slots disponibles
//
// Subvistas definidas en este mismo archivo (por cohesión):
//   • GoalsHeaderView  — encabezado con progreso
//   • GoalRowView      — fila individual de una meta
//   • GoalsFooterView  — pie con mensajes contextuales
//
// EXTENSIBILIDAD:
// - Para mostrar el recuadro expandido/colapsado, agrega un
//   @State var isExpanded: Bool y envuelve la lista en un
//   DisclosureGroup o condiciona su visibilidad.
// - Para navegar a una pantalla de metas completa (lista larga,
//   historial), agrega un NavigationLink en el encabezado hacia
//   una futura GoalsFullView.
// - Para animar el avance de fase, observa `isTransitioningPhase`
//   del ViewModel y muestra un overlay de celebración.
// ============================================================

import SwiftUI

// MARK: - Vista principal del recuadro de metas

struct GoalsSectionView: View {

    @EnvironmentObject var goalsViewModel: GoalsViewModel

    /// ID del filler que el usuario quiere personalizar.
    /// Se pasa al Sheet de AddCustomGoalSheet.
    @State private var selectedFillerID: UUID? = nil

    /// Controla si el Sheet de meta personalizada está visible.
    @State private var showingCustomGoalSheet: Bool = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── 1. Encabezado ────────────────────────────────
            GoalsHeaderView()
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)

            Divider()
                .padding(.horizontal, 16)

            // ── 2. Lista de metas ────────────────────────────
            // Si hay transición de fase, muestra un loader en su lugar
            if goalsViewModel.isTransitioningPhase {
                phaseTransitionView
            } else {
                goalsListSection
            }

            // ── 3. Footer ────────────────────────────────────
            Divider()
                .padding(.horizontal, 16)

            GoalsFooterView()
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
        }
        // Estilo del recuadro: fondo, borde redondeado, sombra suave
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        // EXTENSIBILIDAD: Para agregar sombra al recuadro,
        // descomenta la línea de abajo:
        // .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)

        // Sheet para agregar meta personalizada
        .sheet(isPresented: $showingCustomGoalSheet) {
            if let fillerID = selectedFillerID {
                AddCustomGoalSheet(fillerGoalId: fillerID)
                    .environmentObject(goalsViewModel)
            }
        }
    }

    // MARK: - Lista de filas de metas

    private var goalsListSection: some View {
        VStack(spacing: 0) {
            ForEach(goalsViewModel.activeGoals) { goal in
                GoalRowView(
                    goal: goal,
                    onToggle: {
                        // El usuario tocó el checkbox de esta meta
                        goalsViewModel.toggleGoalCompletion(goal)
                    },
                    onCustomize: {
                        // El usuario tocó "Personalizar" en un filler
                        selectedFillerID       = goal.id
                        showingCustomGoalSheet = true
                    }
                )
                // Separador entre filas (excepto la última)
                if goal.id != goalsViewModel.activeGoals.last?.id {
                    Divider()
                        .padding(.leading, 52)  // Alineado con el texto de la meta
                }
            }
        }
    }

    // MARK: - Vista de transición de fase

    /// Se muestra durante el segundo que tarda en avanzar de fase.
    private var phaseTransitionView: some View {
        HStack(spacing: 12) {
            ProgressView()
                .scaleEffect(0.9)
            // ╔══════════════════════════════════════════════╗
            // ║  PLACEHOLDER DE MENSAJE DE TRANSICIÓN       ║
            // ║  Cambia la cadena de abajo para editar      ║
            // ║  el mensaje que ve el usuario al subir fase.║
            // ╚══════════════════════════════════════════════╝
            Text("\u{1F389} \u{00A1}Completaste todas las metas! Preparando nuevos retos...")  // ← EDITAR
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
    }
}

// ============================================================
// MARK: - Subvista: Encabezado
// ============================================================

/// Muestra el título de la sección, la fase actual, el contador
/// de metas completadas y una barra de progreso.
private struct GoalsHeaderView: View {

    @EnvironmentObject var goalsViewModel: GoalsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // ── Primera fila: título + fase ──────────────────
            HStack(alignment: .firstTextBaseline) {

                // ╔════════════════════════════════════════╗
                // ║  PLACEHOLDER DE TÍTULO DEL RECUADRO   ║
                // ║  Cambia "Mis Metas" para renombrarlo. ║
                // ╚════════════════════════════════════════╝
                Text("Mis Metas")                      // ← EDITAR título del recuadro
                    .font(.headline)
                    .fontWeight(.bold)

                Spacer()

                // Badge de fase actual
                Text("Fase \(goalsViewModel.currentPhase)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.purple.opacity(0.12))
                    .foregroundColor(.purple)
                    .cornerRadius(20)
            }

            // ── Segunda fila: progreso numérico ──────────────
            HStack(spacing: 4) {
                Text("\(goalsViewModel.completedCount)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)
                Text("de \(goalsViewModel.activeGoals.count) metas completadas")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // ── Barra de progreso ────────────────────────────
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Pista (fondo gris)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 7)

                    // Relleno del progreso
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.purple)
                        .frame(
                            // Ancho proporcional al progreso (0.0 → 1.0)
                            width: geo.size.width * goalsViewModel.progressFraction,
                            height: 7
                        )
                        // Animación suave al cambiar el progreso
                        .animation(.easeInOut(duration: 0.35), value: goalsViewModel.progressFraction)
                }
            }
            .frame(height: 7)
        }
    }
}

// ============================================================
// MARK: - Subvista: Fila de meta individual
// ============================================================

/// Renderiza una meta con su checkbox, título, descripción
/// y (si aplica) el botón para personalizarla.
struct GoalRowView: View {

    let goal:        Goal
    let onToggle:    () -> Void    // Callback cuando el usuario toca el checkbox
    let onCustomize: () -> Void    // Callback cuando el usuario toca "Personalizar"

    /// Controla si la descripción está expandida.
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {

                // ── Checkbox ─────────────────────────────────
                Button(action: onToggle) {
                    ZStack {
                        // Círculo de fondo
                        Circle()
                            .fill(goal.isCompleted
                                  ? Color.purple
                                  : Color(.systemGray5))
                            .frame(width: 28, height: 28)

                        // Checkmark (solo visible si completada)
                        if goal.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 2)  // Alineación visual con el texto

                // ── Contenido de la meta ─────────────────────
                VStack(alignment: .leading, spacing: 4) {

                    HStack(alignment: .firstTextBaseline) {
                        // Título de la meta (tachado si completada)
                        Text(goal.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(goal.isCompleted ? .secondary : .primary)
                            .strikethrough(goal.isCompleted, color: .secondary)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer()

                        // Badge de tipo: solo visible para metas filler y custom
                        if goal.goalType == .filler {
                            GoalTypeBadge(label: "Sugerida", color: .orange)
                        } else if goal.goalType == .custom {
                            GoalTypeBadge(label: "Tu meta", color: .teal)
                        }
                    }

                    // Descripción colapsable (toca para expandir/colapsar)
                    if !goal.description.isEmpty {
                        Text(goal.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(isExpanded ? nil : 2)
                            .onTapGesture { withAnimation { isExpanded.toggle() } }
                    }

                    // Fecha de completado (solo si terminada)
                    if let dateStr = goal.formattedCompletedDate {
                        Text("Completada el \(dateStr)")
                            .font(.caption2)
                            .foregroundColor(.purple.opacity(0.7))
                            .padding(.top, 2)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)

            // ── Botón "Personalizar" (solo en fillers) ───────
            // Aparece debajo de la fila si la meta puede reemplazarse.
            if goal.isCustomizable && goal.goalType == .filler {
                Button(action: onCustomize) {
                    HStack(spacing: 6) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.subheadline)
                        // ╔══════════════════════════════════════╗
                        // ║  PLACEHOLDER DE TEXTO DEL BOTÓN     ║
                        // ║  Cambia la cadena de abajo para     ║
                        // ║  renombrar el botón de personalizar.║
                        // ╚══════════════════════════════════════╝
                        Text("Cambiar por una meta propia")   // ← EDITAR
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.purple)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, 56)   // Alineado con el texto de la fila
                .padding(.bottom, 10)
            }
        }
    }
}

// ============================================================
// MARK: - Subvista auxiliar: Badge de tipo de meta
// ============================================================

/// Pequeña etiqueta de color que indica si una meta es
/// "Sugerida" (filler) o "Tu meta" (custom).
private struct GoalTypeBadge: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(color.opacity(0.12))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}

// ============================================================
// MARK: - Subvista: Footer contextual
// ============================================================

/// Muestra mensajes de ayuda al pie del recuadro:
///   - Si hay slots personalizables disponibles, invita al usuario.
///   - Si todas las metas están completadas y está en transición.
///   - Si no hay nada especial, muestra un mensaje motivador.
private struct GoalsFooterView: View {

    @EnvironmentObject var goalsViewModel: GoalsViewModel

    var body: some View {
        Group {
            if goalsViewModel.isTransitioningPhase {
                // Mensaje durante la transición de fase (ya cubierto en la lista,
                // pero el footer puede mostrar un complemento)
                EmptyView()

            } else if goalsViewModel.hasCustomizableSlots {
                // Hay slots disponibles para personalizar
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.orange)
                        .font(.subheadline)

                    // ╔══════════════════════════════════════════╗
                    // ║  PLACEHOLDER DE MENSAJE DEL FOOTER      ║
                    // ║  Cambia la cadena de abajo para editar  ║
                    // ║  el mensaje informativo al usuario.     ║
                    // ╚══════════════════════════════════════════╝
                    // Construye el texto dinámicamente según cuántos slots quedan
                    let slots = goalsViewModel.remainingCustomSlots
                    Text(slots == 1
                         ? "Puedes reemplazar 1 meta por una propia."   // ← EDITAR
                         : "Puedes reemplazar \(slots) metas por tuyas propias.")  // ← EDITAR
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

            } else {
                // Sin slots: mensaje motivador genérico
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                    // ╔══════════════════════════════════════════╗
                    // ║  PLACEHOLDER DE MENSAJE MOTIVADOR       ║
                    // ╚══════════════════════════════════════════╝
                    Text("\u{00A1}Sigue adelante, cada meta cuenta!")   // ← EDITAR
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
