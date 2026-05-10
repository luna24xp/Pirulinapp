// ============================================================
// ViewModels/DiaryViewModel.swift
// ViewModel principal de la aplicación (patrón MVVM).
// Es el intermediario entre todas las vistas y la capa de datos.
// Se inyecta como @EnvironmentObject desde DiaryApp.swift.
//
// EXTENSIBILIDAD:
// - Para nuevos módulos (Metas, Bienestar, Estadísticas), crea
//   ViewModels separados (GoalsViewModel, WellbeingViewModel, etc.)
//   que llamen a los métodos getData* de este ViewModel para
//   obtener datos históricos sin duplicar lógica.
// - Mantén este ViewModel enfocado en el diario; delega
//   responsabilidades específicas a ViewModels especializados.
// ============================================================

import SwiftUI
import Combine

class DiaryViewModel: ObservableObject {

    // ── Estado publicado ─────────────────────────────────────

    /// Todas las entradas del diario, ordenadas de más reciente a más antigua.
    /// @Published garantiza que cualquier vista que lo observe se recargue
    /// automáticamente cuando cambie este arreglo.
    @Published var entries: [DiaryEntry] = []

    // ── Inicializador ────────────────────────────────────────

    init() {
        // Cargar entradas guardadas al iniciar la app
        loadEntries()
    }

    // ============================================================
    // MARK: - Operaciones CRUD de entradas
    // ============================================================

    /// Carga (o recarga) todas las entradas desde el disco.
    /// Llamar después de cualquier operación que modifique los datos.
    func loadEntries() {
        entries = DiaryStorage.shared.loadEntries()
    }

    /// Guarda una nueva entrada del diario.
    /// - Parameters:
    ///   - text:     Texto libre redactado por el usuario.
    ///   - emotions: Las 3 emociones seleccionadas.
    ///   - images:   Las imágenes seleccionadas (pueden ser 0, 1 o 2).
    ///
    /// FLUJO INTERNO:
    ///   1. Guarda cada UIImage en disco vía ImageManager → obtiene nombres de archivo.
    ///   2. Construye un DiaryEntry con esos nombres.
    ///   3. Persiste el DiaryEntry en el JSON vía DiaryStorage.
    ///   4. Recarga la lista de entradas para actualizar la UI.
    func saveEntry(text: String, emotions: [Emotion], images: [UIImage]) {
        // Paso 1: Persistir imágenes y recopilar sus nombres de archivo
        var imageFileNames: [String] = []
        for image in images {
            if let fileName = ImageManager.shared.saveImage(image) {
                imageFileNames.append(fileName)
            }
        }

        // Paso 2 y 3: Crear y persistir la entrada
        let newEntry = DiaryEntry(
            text: text,
            emotions: emotions,
            imageFileNames: imageFileNames
        )
        DiaryStorage.shared.saveEntry(newEntry)

        // Paso 4: Actualizar la lista en memoria → la UI se recarga automáticamente
        loadEntries()
    }

    /// Elimina una entrada y todas sus imágenes asociadas.
    func deleteEntry(_ entry: DiaryEntry) {
        DiaryStorage.shared.deleteEntry(entry)
        loadEntries()
    }

    // ============================================================
    // MARK: - Acceso a imágenes (delegado a ImageManager)
    // ============================================================

    /// Carga una UIImage dado el nombre de archivo guardado en una entrada.
    /// Devuelve nil si el archivo no existe.
    func loadImage(named fileName: String) -> UIImage? {
        ImageManager.shared.loadImage(named: fileName)
    }

    /// Devuelve todas las imágenes del diario para la galería.
    /// Itera por las entradas y carga las imágenes en el orden en que aparecen.
    func loadAllGalleryImages() -> [(entryDate: Date, fileName: String, image: UIImage)] {
        var result: [(entryDate: Date, fileName: String, image: UIImage)] = []
        for entry in entries {
            for fileName in entry.imageFileNames {
                if let image = ImageManager.shared.loadImage(named: fileName) {
                    result.append((entryDate: entry.date, fileName: fileName, image: image))
                }
            }
        }
        return result
    }

    // ============================================================
    // MARK: - Propiedades de utilidad
    // ============================================================

    /// Indica si el usuario ya escribió una entrada para hoy.
    /// EXTENSIBILIDAD: Usar en la pantalla principal para mostrar un recordatorio
    /// si el usuario aún no ha escrito su entrada del día.
    var hasTodayEntry: Bool {
        entries.contains { Calendar.current.isDateInToday($0.date) }
    }

    /// Racha actual de días consecutivos con entrada.
    /// EXTENSIBILIDAD: Mostrar en el perfil del usuario o como motivación.
    var currentStreak: Int {
        var streak = 0
        var checkDate = Calendar.current.startOfDay(for: Date())
        let calendar  = Calendar.current

        // Retrocede día a día mientras exista una entrada para ese día
        while true {
            let hasEntry = entries.contains {
                calendar.isDate($0.date, inSameDayAs: checkDate)
            }
            if hasEntry {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
            } else {
                break
            }
        }
        return streak
    }

    // ============================================================
    // MARK: - Datos para módulos futuros
    // Estos métodos exponen datos históricos listos para consumir
    // desde ViewModels o vistas de módulos que se agreguen después.
    // ============================================================

    /// Historial de emociones con sus fechas.
    /// EXTENSIBILIDAD → Módulo de Bienestar Emocional:
    ///   Llama a este método para construir gráficas de tendencias,
    ///   semanas/meses con más emociones positivas, etc.
    func getEmotionHistory() -> [(date: Date, emotions: [Emotion])] {
        DiaryStorage.shared.getEmotionHistory()
    }

    /// Historial de textos con sus fechas.
    /// EXTENSIBILIDAD → Módulo de Metas / IA:
    ///   Usa los textos para análisis de contenido, búsqueda semántica,
    ///   o como contexto al enviar prompts a un LLM.
    func getTextHistory() -> [(date: Date, text: String)] {
        DiaryStorage.shared.getTextHistory()
    }

    /// Frecuencia de cada emoción en todo el historial.
    /// EXTENSIBILIDAD → Dashboard de estadísticas:
    ///   Úsalo para renderizar un gráfico de barras o de pastel.
    func getEmotionFrequency() -> [Emotion: Int] {
        DiaryStorage.shared.getEmotionFrequency()
    }
}
