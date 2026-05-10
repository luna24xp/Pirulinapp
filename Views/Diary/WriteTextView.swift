// ============================================================
// Views/NewEntry/WriteTextView.swift
// Paso 1 del flujo de nueva entrada: redactar el día libremente.
// El campo de texto es obligatorio (no puede estar vacío).
//
// EXTENSIBILIDAD:
// - Para agregar "Prompts del día" (preguntas que inspiren al usuario),
//   crea un arreglo de preguntas y muestra una aleatoria sobre el
//   TextEditor. El usuario puede tocarla para copiarla al texto.
// - Para agregar plantillas de escritura guiada, agrega un
//   SegmentedControl arriba que cambie entre "Libre" y "Guiado",
//   y en modo guiado muestra campos estructurados.
// - Para añadir un contador de palabras (además del de caracteres),
//   agrega una propiedad calculada que cuente palabras separadas por espacios.
// ============================================================

import SwiftUI

struct WriteTextView: View {

    /// Binding al texto de la entrada. Compartido con NewEntryView.
    @Binding var entryText: String

    /// Controla si el TextEditor está enfocado (muestra el teclado).
    @FocusState private var isTextEditorFocused: Bool

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // ── Instrucción al usuario ───────────────────────
            VStack(alignment: .leading, spacing: 4) {
                Text("Escribe sobre tu día con total libertad.")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Text("No hay respuestas correctas o incorrectas. Este espacio es tuyo.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)

            // PLACEHOLDER: "Pregunta del día" para inspirar al usuario.
            // Para activar, crea un componente DailyPromptView y descomenta:
            // DailyPromptView(onTapPrompt: { text in entryText = text })
            //     .padding(.horizontal, 20)

            // ── Área de texto principal ──────────────────────
            ZStack(alignment: .topLeading) {

                // Fondo del área de texto
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)

                // Placeholder cuando no hay texto escrito
                if entryText.isEmpty {
                    Text("¿Qué pasó hoy? ¿Cómo fue tu día?\nCuéntame todo lo que quieras...")
                        .font(.body)
                        .foregroundColor(Color(.placeholderText))
                        .padding(16)
                        // allowsHitTesting(false) permite tocar "a través" del placeholder
                        // para que el TextEditor capture el toque y abra el teclado.
                        .allowsHitTesting(false)
                }

                // Editor de texto (ScrollView interno incluido en TextEditor)
                TextEditor(text: $entryText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(12)
                    .scrollContentBackground(.hidden) // Quita el fondo blanco por defecto
                    .background(Color.clear)
                    .focused($isTextEditorFocused)
            }
            .frame(minHeight: 240)
            .padding(.horizontal, 20)

            // ── Pie: contador de caracteres ──────────────────
            HStack {
                Spacer()

                // El contador cambia de color cuando hay texto suficiente
                let charCount = entryText.count
                Text("\(charCount) \(charCount == 1 ? "carácter" : "caracteres")")
                    .font(.caption)
                    .foregroundColor(charCount > 0 ? .purple.opacity(0.7) : .secondary)
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .padding(.top, 16)
        // Al aparecer la vista, enfocar el TextEditor para abrir el teclado
        .onAppear {
            // Un pequeño delay evita conflictos con la animación de presentación del sheet
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isTextEditorFocused = true
            }
        }
        // Cerrar el teclado al tocar fuera del TextEditor
        .onTapGesture {
            isTextEditorFocused = false
        }
    }
}
