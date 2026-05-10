// ============================================================
// Storage/ImageManager.swift
// Maneja el guardado, carga y eliminación de imágenes en disco.
// Las imágenes se almacenan como archivos JPEG en una carpeta
// dedicada dentro del directorio de documentos de la app.
//
// EXTENSIBILIDAD:
// - Para agregar compresión avanzada, cambia `compressionQuality`
//   en saveImage() o aplica redimensionado antes de guardar.
// - Para subir imágenes a la nube, agrega métodos asíncronos que
//   usen URLSession o un SDK (Firebase Storage, S3, etc.)
//   y guarda la URL remota en el imageFileName del DiaryEntry.
// - Para generar thumbnails (miniatura para la galería), agrega
//   un método saveThumbnail() que guarde una versión reducida.
// ============================================================

import UIKit
import SwiftUI

class ImageManager {

    // Singleton compartido en toda la app
    static let shared = ImageManager()
    private init() {}

    // Nombre de la carpeta interna donde se guardan las imágenes.
    // ⚠️ No cambiar sin estrategia de migración.
    private let folderName = "diary_images"

    // MARK: - URL de la carpeta de imágenes

    /// Devuelve la URL de la carpeta de imágenes, creándola si no existe.
    private var folderURL: URL? {
        guard let docsURL = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask
        ).first else { return nil }

        let folderURL = docsURL.appendingPathComponent(folderName)

        // Crear la carpeta si no existe todavía
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            try? FileManager.default.createDirectory(
                at: folderURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        return folderURL
    }

    // MARK: - Guardar imagen

    /// Guarda una UIImage como JPEG en el sistema de archivos.
    /// - Parameter image: La imagen a guardar.
    /// - Parameter compressionQuality: 0.0 (baja) a 1.0 (alta). Default 0.8.
    ///   Para ahorrar espacio en dispositivos con poco almacenamiento, usa 0.6.
    /// - Returns: El nombre del archivo generado (UUID.jpg) o nil si falla.
    ///
    /// EXTENSIBILIDAD: Para guardar en formato HEIC (más eficiente en iOS),
    /// reemplaza jpegData por heicData si el dispositivo lo soporta.
    func saveImage(_ image: UIImage, compressionQuality: CGFloat = 0.8) -> String? {
        guard
            let folderURL  = folderURL,
            let imageData  = image.jpegData(compressionQuality: compressionQuality)
        else { return nil }

        let fileName = "\(UUID().uuidString).jpg"
        let fileURL  = folderURL.appendingPathComponent(fileName)

        do {
            try imageData.write(to: fileURL)
            return fileName
        } catch {
            print("⚠️ ImageManager.saveImage – Error al guardar: \(error)")
            return nil
        }
    }

    // MARK: - Cargar imagen por nombre de archivo

    /// Carga y devuelve una UIImage dado su nombre de archivo.
    /// Devuelve nil si el archivo no existe o no se puede leer.
    func loadImage(named fileName: String) -> UIImage? {
        guard let folderURL = folderURL else { return nil }
        let fileURL = folderURL.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }

    // MARK: - Eliminar imagen por nombre de archivo

    /// Elimina el archivo de imagen del disco.
    /// Llamado automáticamente por DiaryStorage.deleteEntry().
    func deleteImage(named fileName: String) {
        guard let folderURL = folderURL else { return }
        let fileURL = folderURL.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: fileURL)
    }

    // MARK: - Cargar todas las imágenes (para la galería)

    /// Devuelve todas las imágenes guardadas con su nombre de archivo.
    /// Útil para construir la vista de galería.
    ///
    /// EXTENSIBILIDAD: Para mejorar rendimiento con muchas imágenes,
    /// implementa paginación (carga en lotes de 20) usando un índice
    /// de inicio como parámetro y guarda un índice de "página actual"
    /// en la GalleryView.
    func loadAllImages() -> [(fileName: String, image: UIImage)] {
        guard
            let folderURL = folderURL,
            let fileNames = try? FileManager.default.contentsOfDirectory(
                atPath: folderURL.path
            )
        else { return [] }

        return fileNames.compactMap { name -> (fileName: String, image: UIImage)? in
            guard let image = loadImage(named: name) else { return nil }
            return (fileName: name, image: image)
        }
    }

    // MARK: - Helper: UIImage → SwiftUI Image

    /// Convierte una UIImage a una SwiftUI Image para uso en vistas.
    func swiftUIImage(from uiImage: UIImage) -> Image {
        Image(uiImage: uiImage)
    }

    // MARK: - Calcular tamaño total en disco

    /// Devuelve el tamaño total de la carpeta de imágenes en bytes.
    /// EXTENSIBILIDAD: Usar en una pantalla de "Configuración" para
    /// mostrar al usuario cuánto espacio ocupa la app.
    func totalStorageSize() -> Int64 {
        guard
            let folderURL = folderURL,
            let fileNames = try? FileManager.default.contentsOfDirectory(
                atPath: folderURL.path
            )
        else { return 0 }

        return fileNames.reduce(0) { total, name in
            let fileURL = folderURL.appendingPathComponent(name)
            let attrs   = try? FileManager.default.attributesOfItem(atPath: fileURL.path)
            let size    = attrs?[.size] as? Int64 ?? 0
            return total + size
        }
    }
}
