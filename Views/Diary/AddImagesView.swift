// ============================================================
// Views/NewEntry/AddImagesView.swift
// Paso 3 del flujo de nueva entrada: agregar hasta 2 imágenes
// del día desde la galería del dispositivo.
// Esta sección es completamente OPCIONAL para el usuario.
//
// REQUISITO en Info.plist:
//   NSPhotoLibraryUsageDescription → descripción de por qué
//   se accede a la galería. Ej:
//   "Usamos tu galería para que puedas adjuntar fotos a tu diario."
//
// EXTENSIBILIDAD:
// - Para agregar la CÁMARA: importa UIKit, crea un
//   UIViewControllerRepresentable que envuelva UIImagePickerController
//   con sourceType = .camera. Añade:
//   NSCameraUsageDescription en Info.plist.
// - Para aumentar el límite de imágenes: cambia `maxImages`
//   y ajusta el texto de instrucción.
// - Para agregar edición de imagen (recortar, filtros): presenta
//   un editor después de seleccionar cada imagen antes de guardarla.
// ============================================================

import SwiftUI
import PhotosUI

struct AddImagesView: View {

    /// Binding a las imágenes seleccionadas. Compartido con NewEntryView.
    @Binding var selectedImages: [UIImage]

    /// Máximo de imágenes por entrada.
    /// EXTENSIBILIDAD: Cambia este valor para permitir más imágenes.
    private let maxImages = 2

    /// Estado del PhotosPicker (ítems seleccionados en el picker nativo)
    @State private var pickerItems: [PhotosPickerItem] = []

    /// Indicador de carga de imágenes
    @State private var isLoadingImages: Bool = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // ── Instrucción al usuario ───────────────────────
            VStack(alignment: .leading, spacing: 4) {
                Text("Agrega hasta \(maxImages) fotos importantes de tu día.")
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text("Esta sección es opcional. Puedes guardar sin fotos.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)

            // ── Botón del selector de imágenes ───────────────
            // PhotosPicker es el picker nativo de iOS 16+.
            // No requiere permiso explícito de NSPhotoLibraryUsageDescription
            // en iOS 16+, pero es buena práctica incluirlo en Info.plist.
            PhotosPicker(
                selection: $pickerItems,
                maxSelectionCount: maxImages,
                matching: .images      // Solo imágenes (no videos ni otros tipos)
            ) {
                HStack(spacing: 10) {
                    // PLACEHOLDER: Reemplaza este ícono con uno personalizado
                    // Image("icono_agregar_foto")
                    Image(systemName: "photo.badge.plus.fill")
                        .font(.title2)

                    Text(selectedImages.isEmpty
                         ? "Seleccionar fotos"
                         : "Cambiar fotos (\(selectedImages.count)/\(maxImages))")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(.systemGray6))
                .foregroundColor(.purple)
                .cornerRadius(14)
                .padding(.horizontal, 20)
            }
            // Reaccionar cuando el usuario selecciona imágenes en el picker
            .onChange(of: pickerItems) { oldValue, newValue in
                loadImagesFromPicker(newValue)
            }

            // EXTENSIBILIDAD: Botón de cámara (descomenta para activar)
            // Una vez creado CameraPickerView, descomenta esto:
            // Button(action: { showCamera = true }) {
            //     Label("Tomar foto ahora", systemImage: "camera.fill")
            //         .frame(maxWidth: .infinity)
            //         .padding()
            //         .background(Color(.systemGray6))
            //         .foregroundColor(.purple)
            //         .cornerRadius(14)
            // }
            // .padding(.horizontal, 20)
            // .sheet(isPresented: $showCamera) {
            //     CameraPickerView(image: $newCameraImage)
            // }

            // ── Indicador de carga ───────────────────────────
            if isLoadingImages {
                HStack {
                    Spacer()
                    ProgressView("Cargando fotos...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }

            // ── Preview de imágenes seleccionadas ────────────
            if !selectedImages.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Fotos seleccionadas:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(selectedImages.indices, id: \.self) { index in
                                imagePreviewCard(image: selectedImages[index], index: index)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 4)
                    }
                }
            }

            Spacer()
        }
        .padding(.top, 16)
    }

    // MARK: - Tarjeta de preview de imagen

    /// Muestra una imagen seleccionada con un botón para eliminarla.
    private func imagePreviewCard(image: UIImage, index: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            // Imagen
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(14)
                .clipped()

            // Botón de eliminación sobre la imagen
            Button(action: { removeImage(at: index) }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.white, Color.black.opacity(0.55))
            }
            .padding(6)
        }
    }

    // MARK: - Cargar imágenes del picker

    /// Carga de forma asíncrona las imágenes seleccionadas en el picker.
    /// Usa async/await para no bloquear el hilo principal.
    private func loadImagesFromPicker(_ items: [PhotosPickerItem]) {
        isLoadingImages = true
        selectedImages  = []

        Task {
            var loadedImages: [UIImage] = []
            for item in items {
                // loadTransferable usa async/await para cargar la imagen
                if let data  = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    loadedImages.append(image)
                }
            }
            // Volver al hilo principal para actualizar la UI
            await MainActor.run {
                selectedImages  = loadedImages
                isLoadingImages = false
            }
        }
    }

    // MARK: - Eliminar imagen

    /// Elimina una imagen de la selección (visual y del picker).
    private func removeImage(at index: Int) {
        guard index < selectedImages.count else { return }
        selectedImages.remove(at: index)
        if index < pickerItems.count {
            pickerItems.remove(at: index)
        }
    }
}
