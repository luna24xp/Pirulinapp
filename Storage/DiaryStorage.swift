// ============================================================
// Storage/DiaryStorage.swift
// Capa de persistencia para las entradas del diario.
// Serializa/deserializa entradas en JSON usando Codable.
//
// EXTENSIBILIDAD:
// - Para migrar a CoreData: crea un DiaryStorageCoreData que
//   implemente el mismo contrato de métodos públicos, y cambia
//   la referencia en DiaryViewModel. Las vistas no necesitan
//   modificarse gracias a este patrón de separación.
// - Para sincronización con CloudKit: agrega lógica de sync
//   aquí, debajo de los métodos locales de lectura/escritura.
// - Para migración de datos entre versiones: crea un método
//   `migrateIfNeeded()` que detecte la versión anterior y
//   transforme los datos al nuevo formato antes de cargarlos.
// ============================================================

import Foundation

class DiaryStorage {

    // Singleton: una sola instancia compartida en toda la app.
    // Para tests unitarios, considera inyectar la dependencia en lugar
    // de usar el singleton directamente.
    static let shared = DiaryStorage()
    private init() {}

    // Nombre del archivo JSON de datos.
    // ⚠️ No cambiar este nombre sin una estrategia de migración,
    // ya que los datos del usuario ya guardados no se encontrarían.
    private let fileName = "diary_entries.json"

    // MARK: - URL del archivo de datos

    private var fileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(fileName)
    }

    // MARK: - Cargar entradas

    /// Carga y devuelve todas las entradas del diario guardadas.
    /// Las ordena de más reciente a más antigua.
    /// Si el archivo no existe o hay error de decodificación, devuelve [].
    func loadEntries() -> [DiaryEntry] {
        guard
            let url  = fileURL,
            let data = try? Data(contentsOf: url)
        else { return [] }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let entries = try decoder.decode([DiaryEntry].self, from: data)
            // Orden descendente: la entrada más reciente aparece primero
            return entries.sorted { $0.date > $1.date }
        } catch {
            // Si hay un error de decodificación, no silenciarlo en desarrollo.
            // EXTENSIBILIDAD: Aquí podrías intentar una estrategia de migración
            // antes de devolver vacío.
            print("⚠️ DiaryStorage.loadEntries – Error al decodificar: \(error)")
            return []
        }
    }

    // MARK: - Guardar una entrada

    /// Guarda o actualiza una entrada.
    /// Si ya existe una entrada con el mismo `id`, la reemplaza (actualización).
    /// Si no existe, la agrega al arreglo.
    func saveEntry(_ entry: DiaryEntry) {
        var entries = loadEntries()

        if let existingIndex = entries.firstIndex(where: { $0.id == entry.id }) {
            // Modo actualización: reemplazar entrada existente
            entries[existingIndex] = entry
        } else {
            // Modo creación: agregar nueva entrada
            entries.append(entry)
        }

        writeEntries(entries)
    }

    // MARK: - Eliminar una entrada

    /// Elimina una entrada y sus imágenes asociadas del sistema de archivos.
    func deleteEntry(_ entry: DiaryEntry) {
        // Primero eliminar las imágenes del FileManager
        for fileName in entry.imageFileNames {
            ImageManager.shared.deleteImage(named: fileName)
        }

        // Luego eliminar la entrada del archivo JSON
        var entries = loadEntries()
        entries.removeAll { $0.id == entry.id }
        writeEntries(entries)
    }

    // MARK: - Escritura interna del JSON

    /// Serializa el arreglo de entradas y lo escribe al disco.
    /// Usa escritura atómica para evitar corrupción de datos.
    private func writeEntries(_ entries: [DiaryEntry]) {
        guard let url = fileURL else { return }

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted // Más legible en depuración
            let data = try encoder.encode(entries)
            try data.write(to: url, options: .atomicWrite)
        } catch {
            print("⚠️ DiaryStorage.writeEntries – Error al guardar: \(error)")
        }
    }

    // ============================================================
    // MARK: - Métodos para módulos futuros
    // Estos métodos exponen datos históricos para funcionalidades
    // que se agregarán en versiones posteriores de la app.
    // Por ahora solo recopilan y devuelven los datos almacenados.
    // ============================================================

    /// Devuelve el historial de emociones por fecha.
    ///
    /// EXTENSIBILIDAD (Módulo de Bienestar Emocional):
    /// Usa este método para construir gráficas de tendencias emocionales,
    /// calcular la emoción más frecuente del mes, o identificar patrones.
    /// Ejemplo de uso futuro:
    ///   let history = DiaryStorage.shared.getEmotionHistory()
    ///   let thisMonth = history.filter { Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month) }
    func getEmotionHistory() -> [(date: Date, emotions: [Emotion])] {
        return loadEntries().map { (date: $0.date, emotions: $0.emotions) }
    }

    /// Devuelve el historial de textos por fecha.
    ///
    /// EXTENSIBILIDAD (Módulo de Análisis / Metas):
    /// Usa este método para análisis de contenido, búsqueda de palabras clave,
    /// o para pasar los textos a un modelo de lenguaje que genere retroalimentación
    /// personalizada sobre el progreso del usuario.
    func getTextHistory() -> [(date: Date, text: String)] {
        return loadEntries().map { (date: $0.date, text: $0.text) }
    }

    /// Devuelve la frecuencia de cada emoción en todo el historial.
    ///
    /// EXTENSIBILIDAD (Dashboard de estadísticas):
    /// Usa este método para mostrar al usuario cuáles son sus emociones
    /// más frecuentes en una gráfica de barras o de pie.
    func getEmotionFrequency() -> [Emotion: Int] {
        var frequency: [Emotion: Int] = [:]
        for entry in loadEntries() {
            for emotion in entry.emotions {
                frequency[emotion, default: 0] += 1
            }
        }
        return frequency
    }
}
