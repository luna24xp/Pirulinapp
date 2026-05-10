// ============================================================
// Views/NewEntry/EmotionPickerView.swift
// Paso 2 del flujo de nueva entrada: seleccionar exactamente 3
// emociones importantes del día.
//
// EXTENSIBILIDAD:
// - Para cambiar el número de emociones seleccionables, modifica
//   la constante `maxEmotions` y la validación correspondiente
//   en NewEntryView.canProceedToNextStep.
// - Para agregar nuevas emociones al catálogo, añade casos en
//   el enum Emotion (Models/Emotion.swift). Aparecerán aquí
//   automáticamente gracias a Emotion.allCases.
// - Para agrupar emociones por categoría (positivas/negativas),
//   usa Emotion.allCases agrupados por `emotion.category` y
//   muéstralos en secciones separadas.
// ============================================================

import SwiftUI

struct EmotionPickerView: View {

    /// Binding a las emociones seleccionadas. Compartido con NewEntryView.
    @Binding var selectedEmotions: [Emotion]

    /// Número máximo de emociones que el usuario puede seleccionar.
    /// EXTENSIBILIDAD: Cambia este valor para permitir más o menos selecciones.
    private let maxEmotions = 3

    /// Layout de cuadrícula: 2 columnas de ancho flexible.
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // ── Instrucción al usuario ───────────────────────
            VStack(alignment: .leading, spacing: 4) {
                Text("Selecciona las \(maxEmotions) emociones más importantes.")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("¿Qué sentiste con más fuerza hoy?")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)

            // ── Indicador de emociones seleccionadas ─────────
            EmotionSelectionIndicatorView(
                selected: selectedEmotions,
                max: maxEmotions
            )
            .padding(.horizontal, 20)

            // ── Cuadrícula de emociones ──────────────────────
            // Usamos ScrollView + LazyVGrid para evitar que el contenido
            // quede cortado en iPhones más pequeños (SE, mini).
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(Emotion.allCases) { emotion in
                        EmotionGridItemView(
                            emotion: emotion,
                            isSelected: selectedEmotions.contains(emotion),
                            isDisabled: selectedEmotions.count >= maxEmotions
                                        && !selectedEmotions.contains(emotion),
                            onTap: { toggleEmotion(emotion) }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .padding(.top, 12)
    }

    // MARK: - Toggle de selección

    /// Agrega o elimina una emoción de la selección.
    private func toggleEmotion(_ emotion: Emotion) {
        if selectedEmotions.contains(emotion) {
            // Deseleccionar: quitar del arreglo
            selectedEmotions.removeAll { $0 == emotion }
        } else if selectedEmotions.count < maxEmotions {
            // Seleccionar: solo si no se ha alcanzado el máximo
            selectedEmotions.append(emotion)
        }
        // Si ya hay maxEmotions y la emoción no está seleccionada, no se hace nada.
        // El usuario debe deseleccionar una para elegir otra.
    }
}

// MARK: - Indicador de slots seleccionados

/// Muestra círculos (vacíos o con emoji) que indican cuántas emociones
/// se han seleccionado de las 3 requeridas.
struct EmotionSelectionIndicatorView: View {

    let selected: [Emotion]
    let max: Int

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ForEach(0..<max, id: \.self) { index in
                if index < selected.count {
                    // Slot ocupado: muestra el emoji de la emoción
                    Text(selected[index].emoji)
                        .font(.title2)
                        .transition(.scale)
                } else {
                    // Slot vacío: círculo punteado
                    Circle()
                        .stroke(
                            style: StrokeStyle(lineWidth: 1.5, dash: [4])
                        )
                        .foregroundColor(Color.gray.opacity(0.4))
                        .frame(width: 30, height: 30)
                }
            }

            Spacer()

            // Contador numérico
            Text("\(selected.count)/\(max)")
                .font(.subheadline)
                .fontWeight(selected.count == max ? .bold : .regular)
                .foregroundColor(selected.count == max ? .purple : .secondary)
        }
        .animation(.easeInOut(duration: 0.2), value: selected.count)
    }
}

// MARK: - Item individual de emoción en la cuadrícula

/// Celda tocable que representa una emoción en la cuadrícula.
/// Muestra emoji + nombre, con estado visual de selección.
struct EmotionGridItemView: View {

    let emotion:    Emotion
    let isSelected: Bool
    let isDisabled: Bool   // True cuando ya se seleccionaron 3 y esta no está elegida
    let onTap:      () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Text(emotion.emoji)
                    .font(.title3)

                Text(emotion.rawValue)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(itemTextColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Spacer()

                // Checkmark de selección
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(emotion.color)
                        .font(.subheadline)
                        .transition(.scale)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(itemBackground)
            .overlay(itemBorder)
            .cornerRadius(12)
            .opacity(isDisabled ? 0.45 : 1.0) // Atenúa las opciones no disponibles
        }
        .buttonStyle(PlainButtonStyle()) // Evita el efecto de resaltado azul del sistema
        .disabled(isDisabled)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    // ── Helpers de estilo ────────────────────────────────────

    private var itemTextColor: Color {
        isSelected ? emotion.color : .primary
    }

    private var itemBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(isSelected
                  ? emotion.color.opacity(0.15)
                  : Color(.systemGray6))
    }

    private var itemBorder: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(
                isSelected ? emotion.color : Color.clear,
                lineWidth: 2
            )
    }
}
