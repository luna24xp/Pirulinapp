// ============================================================
// Views/Journal/EntryDetailView.swift
// Muestra todos los datos de una entrada: fecha, emociones,
// texto e imágenes (si las hay).
//
// EXTENSIBILIDAD:
// - Para habilitar EDICIÓN de entradas: agrega un botón "Editar"
//   en el toolbar que presente NewEntryView con los datos pre-cargados.
//   Necesitarás agregar un modo "edición" a NewEntryView y pasar
//   la entrada existente como parámetro opcional.
// - Para agregar COMPARTIR entrada: usa ShareLink de iOS 16
//   para exportar el texto o una captura de pantalla.
// - Para mostrar datos relacionados de metas (futuro): agrega una
//   sección al final que muestre las metas activas de ese día.
// ============================================================

import SwiftUI

struct EntryDetailView: View {

    @EnvironmentObject var diaryViewModel: DiaryViewModel

    let entry: DiaryEntry

    // Imagen seleccionada para vista en pantalla completa
    @State private var selectedImageName: String? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                // ── Encabezado con fecha ─────────────────────
                entryHeader

                // ── Emociones del día ────────────────────────
                emotionsSection

                Divider()

                // ── Texto redactado ──────────────────────────
                textSection

                // ── Imágenes (si existen) ────────────────────
                if !entry.imageFileNames.isEmpty {
                    Divider()
                    imagesSection
                }

                // EXTENSIBILIDAD: Agrega aquí nuevas secciones para
                // datos adicionales de futuras versiones.
                // Ejemplo:
                // if let goal = entry.relatedGoal {
                //     Divider()
                //     GoalSummaryView(goal: goal)
                // }

                Spacer(minLength: 48)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .navigationTitle(entry.weekdayName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // EXTENSIBILIDAD: Descomenta y completa para habilitar edición.
            // ToolbarItem(placement: .navigationBarTrailing) {
            //     Button("Editar") { showEditSheet = true }
            // }
        }
        // Vista de imagen en pantalla completa
        .sheet(item: $selectedImageName) { fileName in
            if let uiImage = diaryViewModel.loadImage(named: fileName) {
                FullScreenImageView(image: uiImage)
            }
        }
    }

    // MARK: - Subvistas

    private var entryHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.weekdayName)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.purple)
                .textCase(.uppercase)
                .tracking(1.5)

            Text(entry.formattedDate)
                .font(.title2)
                .fontWeight(.bold)
        }
    }

    private var emotionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Así me sentí", systemImage: "heart.fill")
                .font(.headline)
                .foregroundColor(.secondary)

            // Chips de emociones seleccionadas
            HStack(spacing: 10) {
                ForEach(entry.emotions) { emotion in
                    EmotionChipView(emotion: emotion)
                }
            }
        }
    }

    private var textSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Lo que escribí", systemImage: "pencil")
                .font(.headline)
                .foregroundColor(.secondary)

            Text(entry.text)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(7)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var imagesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Fotos del día", systemImage: "photo")
                .font(.headline)
                .foregroundColor(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(entry.imageFileNames, id: \.self) { fileName in
                        if let uiImage = diaryViewModel.loadImage(named: fileName) {
                            Button(action: { selectedImageName = fileName }) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(14)
                                    .clipped()
                            }
                        }
                    }
                }
                .padding(.bottom, 4)
            }
        }
    }
}

// MARK: - Chip de emoción para detalle

/// Muestra una emoción como una "pastilla" (chip) con emoji, nombre y color.
/// Reutilizado también en EmotionPickerView.
struct EmotionChipView: View {

    let emotion: Emotion

    var body: some View {
        HStack(spacing: 6) {
            Text(emotion.emoji)
                .font(.body)
            Text(emotion.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(emotion.color.opacity(0.15))
        .foregroundColor(emotion.color)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(emotion.color.opacity(0.4), lineWidth: 1.2)
        )
    }
}

// MARK: - Extensión para hacer String: Identifiable (para .sheet(item:))

/// Permite usar String como item en .sheet(item:) para mostrar imagenes.
extension String: @retroactive Identifiable {
    public var id: String { self }
}
