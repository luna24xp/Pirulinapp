// ============================================================
// Views/Goals/AddCustomGoalSheet.swift
// Ruta: DiaryApp/Views/Goals/AddCustomGoalSheet.swift
//
// Hoja modal que le permite al usuario crear una meta propia
// para reemplazar uno de los slots de relleno (filler) en Fase 2+.
//
// FLUJO:
//   1. GoalsSectionView detecta que el usuario tocó "Personalizar"
//      en un filler → presenta este Sheet con el ID del filler.
//   2. El usuario escribe un título y una descripción.
//   3. Al tocar "Guardar meta", GoalsViewModel.replaceFillerWithCustomGoal()
//      reemplaza el filler con la meta custom.
//
// EXTENSIBILIDAD:
// - Para agregar sugerencias de metas (chips tocables que
//   pre-llenan el formulario), agrega un ScrollView horizontal
//   con chips debajo del campo de título.
// - Para permitir editar metas custom ya guardadas, presenta este
//   mismo Sheet pasando los valores existentes como `initialTitle`
//   y `initialDescription`.
// ============================================================

import SwiftUI

struct AddCustomGoalSheet: View {

    // ── Dependencias ─────────────────────────────────────────
    @EnvironmentObject var goalsViewModel: GoalsViewModel
    @Environment(\.dismiss) var dismiss

    /// ID de la meta filler que será reemplazada.
    /// Viene de GoalsSectionView cuando el usuario toca "Personalizar".
    let fillerGoalId: UUID

    // ── Estado del formulario ────────────────────────────────
    @State private var titleText:       String = ""
    @State private var descriptionText: String = ""
    @State private var showValidationError: Bool = false

    /// Controla el foco del teclado en el campo de título.
    @FocusState private var isTitleFocused: Bool

    // MARK: - Constantes de validación

    /// Longitud mínima del título para poder guardar.
    private let minTitleLength = 5

    /// Longitud máxima del título.
    private let maxTitleLength = 60

    /// Longitud máxima de la descripción.
    private let maxDescLength = 200

    // MARK: - Body

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // ── Encabezado explicativo ───────────────
                    headerSection

                    // ── Campo: Título de la meta ─────────────
                    titleFieldSection

                    // ── Campo: Descripción ───────────────────
                    descriptionFieldSection

                    // ── Mensaje de error de validación ───────
                    if showValidationError {
                        Text("El título debe tener al menos \(minTitleLength) caracteres.")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 4)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .navigationTitle("Nueva meta personal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Botón cancelar (izquierda)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                        .foregroundColor(.secondary)
                }

                // Botón guardar (derecha) — desactivado si el título está vacío
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        saveCustomGoal()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(canSave ? .purple : .gray)
                    .disabled(!canSave)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        // Abrir teclado automáticamente en el campo título
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTitleFocused = true
            }
        }
    }

    // MARK: - Secciones de la vista

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // ╔══════════════════════════════════════════════╗
            // ║  PLACEHOLDER DE TEXTO DEL ENCABEZADO        ║
            // ║  Cambia las cadenas de abajo para           ║
            // ║  personalizar el mensaje al usuario.         ║
            // ╚══════════════════════════════════════════════╝
            Text("Crea tu propia meta")    // ← EDITAR si quieres otro título
                .font(.headline)

            Text("Escribe una meta que sea significativa para ti."
               + " Puede ser cualquier reto o hábito que quieras lograr.")  // ← EDITAR
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding(16)
        .background(Color.purple.opacity(0.07))
        .cornerRadius(12)
    }

    private var titleFieldSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Etiqueta del campo
            Text("Título de tu meta")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            // Campo de texto
            TextField("Ej: Leer 10 minutos al día", text: $titleText)
                .font(.body)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .focused($isTitleFocused)
                // Limitar a maxTitleLength caracteres
                .onChange(of: titleText) { newValue in
                    if newValue.count > maxTitleLength {
                        titleText = String(newValue.prefix(maxTitleLength))
                    }
                    // Ocultar error mientras el usuario escribe
                    if showValidationError { showValidationError = false }
                }

            // Contador de caracteres del título
            HStack {
                Spacer()
                Text("\(titleText.count)/\(maxTitleLength)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var descriptionFieldSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Etiqueta del campo
            Text("Descripción (opcional)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            // Área de texto para la descripción
            ZStack(alignment: .topLeading) {
                // Fondo del área
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))

                // Placeholder cuando está vacío
                if descriptionText.isEmpty {
                    Text("¿Cómo sabrás que completaste esta meta?")
                        .font(.body)
                        .foregroundColor(Color(.placeholderText))
                        .padding(12)
                        .allowsHitTesting(false)
                }

                // TextEditor real
                TextEditor(text: $descriptionText)
                    .font(.body)
                    .padding(8)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .onChange(of: descriptionText) { newValue in
                        if newValue.count > maxDescLength {
                            descriptionText = String(newValue.prefix(maxDescLength))
                        }
                    }
            }
            .frame(minHeight: 100)

            // Contador de caracteres de la descripción
            HStack {
                Spacer()
                Text("\(descriptionText.count)/\(maxDescLength)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }

    // MARK: - Lógica de guardado

    /// true si el formulario tiene datos válidos para guardar.
    private var canSave: Bool {
        titleText.trimmingCharacters(in: .whitespacesAndNewlines).count >= minTitleLength
    }

    /// Valida y guarda la meta personalizada.
    private func saveCustomGoal() {
        let cleanTitle = titleText.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanDesc  = descriptionText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard cleanTitle.count >= minTitleLength else {
            showValidationError = true
            return
        }

        // Delegamos la lógica de reemplazo al ViewModel
        goalsViewModel.replaceFillerWithCustomGoal(
            goalId:      fillerGoalId,
            title:       cleanTitle,
            description: cleanDesc.isEmpty ? "Meta personal" : cleanDesc
        )

        dismiss()
    }
}
