// ============================================================
// Views/NewEntry/NewEntryView.swift
// Vista controladora del flujo de 3 pasos para crear una nueva
// entrada del diario:
//   Paso 1 → WriteTextView    (redactar el día — OBLIGATORIO)
//   Paso 2 → EmotionPickerView (seleccionar 3 emociones — OBLIGATORIO)
//   Paso 3 → AddImagesView    (agregar imágenes — OPCIONAL)
//
// EXTENSIBILIDAD:
// Para agregar un nuevo paso al flujo (ej. "¿Lograste alguna meta hoy?"):
//   1. Agrega un caso al enum `EntryStep` (ej. `.reviewGoals`).
//   2. Crea la vista correspondiente (ej. ReviewGoalsView.swift).
//   3. Agrega la vista en el switch de `currentStepView`.
//   4. Actualiza `stepTitle`, `stepNumber`, y la lógica de navegación.
//   5. Añade un nodo en `StepProgressView`.
//   6. Agrega el dato recopilado como @State y pásalo a saveEntry().
// ============================================================

import SwiftUI

struct NewEntryView: View {

    @EnvironmentObject var diaryViewModel: DiaryViewModel
    @Environment(\.dismiss)  var dismiss

    // ── Paso actual del flujo ────────────────────────────────
    @State private var currentStep: EntryStep = .writeText

    // ── Datos recopilados en cada paso ───────────────────────
    @State private var entryText:        String   = ""
    @State private var selectedEmotions: [Emotion] = []
    @State private var selectedImages:   [UIImage] = []

    // MARK: - Enum de pasos

    /// Define todos los pasos del flujo de creación de una entrada.
    /// EXTENSIBILIDAD: Agrega casos aquí para nuevos pasos.
    enum EntryStep: CaseIterable {
        case writeText      // Paso 1: Redactar el día
        case pickEmotions   // Paso 2: Seleccionar emociones
        case addImages      // Paso 3: Agregar imágenes (opcional)
    }

    // Título de la barra de navegación según el paso activo
    var stepTitle: String {
        switch currentStep {
        case .writeText:    return "¿Cómo estuvo tu día?"
        case .pickEmotions: return "¿Cómo te sentiste?"
        case .addImages:    return "Fotos del día"
        }
    }

    // Descripción del paso para el indicador de progreso
    var stepLabel: String {
        switch currentStep {
        case .writeText:    return "Paso 1 de 3"
        case .pickEmotions: return "Paso 2 de 3"
        case .addImages:    return "Paso 3 de 3"
        }
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                // ── Indicador de progreso ────────────────────
                VStack(spacing: 4) {
                    StepProgressView(currentStep: currentStep)
                        .padding(.horizontal, 24)
                        .padding(.top, 12)

                    Text(stepLabel)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                }

                // ── Vista del paso actual ────────────────────
                currentStepView
                    .transition(.opacity) // Transición suave entre pasos

                // ── Botones de navegación ────────────────────
                EntryNavigationButtonsView(
                    currentStep: currentStep,
                    canProceed:  canProceedToNextStep,
                    onBack:      goToPreviousStep,
                    onNext:      goToNextStep,
                    onSave:      saveAndDismiss
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .padding(.top, 8)
            }
            .navigationTitle(stepTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                        .foregroundColor(.red)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        // Evitar cierre accidental con el gesto de deslizar hacia abajo
        .interactiveDismissDisabled(true)
    }

    // MARK: - Vista del paso activo

    @ViewBuilder
    private var currentStepView: some View {
        switch currentStep {
        case .writeText:
            WriteTextView(entryText: $entryText)

        case .pickEmotions:
            EmotionPickerView(selectedEmotions: $selectedEmotions)

        case .addImages:
            AddImagesView(selectedImages: $selectedImages)

        // EXTENSIBILIDAD: Agrega aquí los casos de nuevos pasos.
        // Ejemplo:
        // case .reviewGoals:
        //     ReviewGoalsView(completedGoals: $completedGoals)
        }
    }

    // MARK: - Validación para avanzar al siguiente paso

    /// Devuelve true si el paso actual tiene datos válidos para continuar.
    /// Las imágenes siempre son opcionales (paso 3 siempre permite avanzar).
    private var canProceedToNextStep: Bool {
        switch currentStep {
        case .writeText:
            // El texto no puede estar vacío o solo tener espacios en blanco
            return !entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        case .pickEmotions:
            // Se deben seleccionar exactamente 3 emociones
            return selectedEmotions.count == 3

        case .addImages:
            // Las imágenes son opcionales, siempre se puede guardar
            return true
        }
    }

    // MARK: - Navegación entre pasos

    private func goToPreviousStep() {
        switch currentStep {
        case .writeText:    break               // No hay paso anterior al primero
        case .pickEmotions: currentStep = .writeText
        case .addImages:    currentStep = .pickEmotions
        }
    }

    private func goToNextStep() {
        switch currentStep {
        case .writeText:    currentStep = .pickEmotions
        case .pickEmotions: currentStep = .addImages
        case .addImages:    saveAndDismiss()    // El último paso guarda directamente
        }
    }

    // MARK: - Guardar y cerrar

    private func saveAndDismiss() {
        diaryViewModel.saveEntry(
            text:     entryText,
            emotions: selectedEmotions,
            images:   selectedImages
        )
        dismiss()
    }
}

// MARK: - Indicador de progreso visual

/// Muestra los 3 pasos del flujo como nodos conectados por líneas.
/// EXTENSIBILIDAD: Al agregar pasos, replica el patrón de nodos y líneas.
struct StepProgressView: View {

    let currentStep: NewEntryView.EntryStep

    // Determina el índice numérico del paso actual para comparaciones
    private var stepIndex: Int {
        switch currentStep {
        case .writeText:    return 0
        case .pickEmotions: return 1
        case .addImages:    return 2
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            stepNode(index: 0, label: "Texto")
            connector(active: stepIndex >= 1)
            stepNode(index: 1, label: "Emociones")
            connector(active: stepIndex >= 2)
            stepNode(index: 2, label: "Fotos")
        }
    }

    private func stepNode(index: Int, label: String) -> some View {
        VStack(spacing: 5) {
            Circle()
                .fill(stepIndex >= index ? Color.purple : Color.gray.opacity(0.3))
                .frame(width: 14, height: 14)
                .overlay(
                    // Ícono de check en pasos ya completados
                    Group {
                        if stepIndex > index {
                            Image(systemName: "checkmark")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                )
            Text(label)
                .font(.caption2)
                .foregroundColor(stepIndex >= index ? .purple : .secondary)
        }
    }

    private func connector(active: Bool) -> some View {
        Rectangle()
            .fill(active ? Color.purple : Color.gray.opacity(0.3))
            .frame(height: 2)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 18)
    }
}

// MARK: - Botones de navegación del flujo

/// Muestra los botones "Atrás" y "Continuar / Guardar entrada".
struct EntryNavigationButtonsView: View {

    let currentStep:  NewEntryView.EntryStep
    let canProceed:   Bool
    let onBack:       () -> Void
    let onNext:       () -> Void
    let onSave:       () -> Void

    // Texto del botón principal según el paso
    private var nextButtonLabel: String {
        switch currentStep {
        case .writeText:    return "Continuar"
        case .pickEmotions: return "Continuar"
        case .addImages:    return "Guardar entrada"
        }
    }

    var body: some View {
        HStack(spacing: 12) {

            // ── Botón Atrás (oculto en el primer paso) ───────
            if currentStep != .writeText {
                Button(action: onBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Atrás")
                    }
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                }
            }

            // ── Botón Continuar o Guardar ─────────────────────
            Button(action: {
                if currentStep == .addImages {
                    onSave()
                } else {
                    onNext()
                }
            }) {
                HStack(spacing: 4) {
                    Text(nextButtonLabel)
                    if currentStep != .addImages {
                        Image(systemName: "chevron.right")
                    }
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(canProceed ? Color.purple : Color.gray.opacity(0.3))
                .foregroundColor(canProceed ? .white : Color(.systemGray2))
                .cornerRadius(12)
            }
            .disabled(!canProceed)
        }
    }
}
