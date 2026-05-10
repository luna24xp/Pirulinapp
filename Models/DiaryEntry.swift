// ============================================================
// Models/DiaryEntry.swift
// Modelo de datos que representa UNA entrada del diario.
//
// EXTENSIBILIDAD:
// - Para agregar campos nuevos (ej. ubicación, clima, calificación
//   general del día, metas completadas), añade propiedades aquí.
// - Al agregar propiedades opcionales con valor por defecto,
//   los datos existentes guardados seguirán siendo compatibles.
// - Si agregas propiedades no-opcionales, necesitarás una estrategia
//   de migración en DiaryStorage (ver ese archivo).
// ============================================================

import Foundation

struct DiaryEntry: Codable, Identifiable {

    // ── Identificadores ─────────────────────────────────────
    var id: UUID          // Identificador único de cada entrada
    var date: Date        // Fecha y hora de creación de la entrada

    // ── Contenido principal ──────────────────────────────────
    var text: String      // Texto libre redactado por el usuario (obligatorio)

    /// Las emociones seleccionadas por el usuario.
    /// Actualmente siempre son 3 (forzado por EmotionPickerView).
    /// EXTENSIBILIDAD: Si se quiere cambiar el número, ajusta también
    /// la constante `maxEmotions` en EmotionPickerView.swift.
    var emotions: [Emotion]

    /// Nombres de archivo de las imágenes guardadas en FileManager.
    /// Máximo 2 entradas. El arreglo puede estar vacío (imágenes son opcionales).
    /// EXTENSIBILIDAD: Para subir a la nube, guarda aquí las URLs remotas
    /// en lugar de nombres de archivo locales y ajusta ImageManager.
    var imageFileNames: [String]

    // ── Inicializador ────────────────────────────────────────
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        text: String,
        emotions: [Emotion],
        imageFileNames: [String] = []
    ) {
        self.id = id
        self.date = date
        self.text = text
        self.emotions = emotions
        self.imageFileNames = imageFileNames
    }

    // ── Propiedades calculadas de formato de fecha ───────────

    /// Fecha larga en español: "10 de mayo de 2025"
    var formattedDate: String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        f.locale = Locale(identifier: "es_MX")
        return f.string(from: date)
    }

    /// Fecha corta para listas: "10 may"
    var shortDate: String {
        let f = DateFormatter()
        f.dateFormat = "dd MMM"
        f.locale = Locale(identifier: "es_MX")
        return f.string(from: date)
    }

    /// Día de la semana en español: "Lunes", "Martes", etc.
    var weekdayName: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        f.locale = Locale(identifier: "es_MX")
        return f.string(from: date).capitalized
    }

    /// Preview corto del texto para listas (primeros 80 caracteres)
    var textPreview: String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count > 80 {
            return String(trimmed.prefix(80)) + "..."
        }
        return trimmed
    }
}
