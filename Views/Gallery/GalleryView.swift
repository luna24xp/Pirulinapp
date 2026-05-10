// ============================================================
// Views/Gallery/GalleryView.swift
// Galería interna de la app: muestra todas las imágenes que el
// usuario ha adjuntado a sus entradas del diario.
//
// EXTENSIBILIDAD:
// - Para agregar filtros por fecha: agrega un DatePicker o
//   SegmentedControl para mostrar imágenes de semanas o meses
//   específicos. Usa el campo `entryDate` del tuple devuelto
//   por `loadAllGalleryImages()`.
// - Para agregar la opción de EXPORTAR imágenes a la galería
//   del sistema: usa UIImageWriteToSavedPhotosAlbum o
//   PhotosUI.PHPhotoLibrary en un botón de acción larga.
//   Requiere NSPhotoLibraryAddUsageDescription en Info.plist.
// - Para mostrar la entrada asociada a cada imagen: navega a
//   EntryDetailView cuando el usuario toca una imagen, en lugar
//   de mostrar la vista de pantalla completa.
// ============================================================

import SwiftUI

struct GalleryView: View {

    @EnvironmentObject var diaryViewModel: DiaryViewModel

    /// Imagen actualmente seleccionada para vista de pantalla completa
    @State private var selectedImage: UIImage? = nil

    /// Controla si se muestra la vista de pantalla completa
    @State private var showingFullScreen: Bool = false

    /// Layout de 3 columnas con espaciado mínimo (estilo iOS Fotos)
    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    /// Todas las imágenes de todas las entradas del diario
    private var allImages: [(entryDate: Date, fileName: String, image: UIImage)] {
        diaryViewModel.loadAllGalleryImages()
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            Group {
                if allImages.isEmpty {
                    EmptyGalleryView()
                } else {
                    galleryGrid
                }
            }
            .navigationTitle("Mi Galería")
            .toolbar {
                // Contador de imágenes en la esquina superior derecha
                if !allImages.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Text("\(allImages.count) \(allImages.count == 1 ? "foto" : "fotos")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            // Pantalla completa al tocar una imagen
            .sheet(isPresented: $showingFullScreen) {
                if let image = selectedImage {
                    FullScreenImageView(image: image)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Cuadrícula de imágenes

    private var galleryGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(allImages, id: \.fileName) { item in
                    Button(action: {
                        selectedImage    = item.image
                        showingFullScreen = true
                    }) {
                        Image(uiImage: item.image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)   // Cuadrado 1:1
                            .clipped()
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

// MARK: - Vista de imagen en pantalla completa

/// Muestra una imagen ocupando toda la pantalla con fondo negro.
/// El usuario puede cerrar deslizando hacia abajo o tocando "Cerrar".
struct FullScreenImageView: View {

    let image: UIImage
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") { dismiss() }
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            // Fondo de la NavigationBar también negro para coherencia
            .toolbarBackground(Color.black.opacity(0.7), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Vista de galería vacía

/// Se muestra cuando el usuario no ha adjuntado ninguna imagen todavía.
struct EmptyGalleryView: View {

    var body: some View {
        VStack(spacing: 20) {

            // PLACEHOLDER: Reemplaza este ícono con una ilustración personalizada.
            // Para activar imagen propia:
            // Image("ilustracion_galeria_vacia")
            //     .resizable()
            //     .aspectRatio(contentMode: .fit)
            //     .frame(width: 200, height: 200)
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 80))
                .foregroundColor(.purple.opacity(0.35))

            Text("Tu galería está vacía")
                .font(.title2)
                .fontWeight(.bold)

            Text("Las fotos que agregues en tus entradas\ndel diario aparecerán aquí.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
    }
}
