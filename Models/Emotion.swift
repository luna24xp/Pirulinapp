// ============================================================
// Models/Emotion.swift
// Define el catálogo completo de emociones disponibles en la app.
//
// EXTENSIBILIDAD:
// - Para AGREGAR una emoción: añade un caso al enum con su rawValue
//   en español, y agrega su emoji, color y categoría en los switches.
// - Para QUITAR una emoción: elimina el caso (los datos guardados
//   que la contengan podrían fallar al decodificar; agrega un
//   caso `unknown` con CodingKey personalizado si necesitas
//   retrocompatibilidad).
// - Los colores y emojis son la identidad visual de cada emoción
//   y se usan en EmotionPickerView, EntryDetailView y en el
//   futuro módulo de estadísticas emocionales.
// ============================================================

import SwiftUI

// MARK: - Enum principal de Emociones

enum Emotion: String, Codable, CaseIterable, Identifiable {

    // ── Emociones positivas ──────────────────────────────────
    case alegria      = "Alegría"
    case curiosidad   = "Curiosidad"
    case esperanza    = "Esperanza"
    case confianza    = "Confianza"
    case tranquilidad = "Tranquilidad"
    case orgullo      = "Orgullo"
    case gratitud     = "Gratitud"

    // ── Emociones neutras ────────────────────────────────────
    case apatia       = "Apatía"

    // ── Emociones negativas ──────────────────────────────────
    case ansiedad     = "Ansiedad"
    case soledad      = "Soledad"
    case frustracion  = "Frustración"
    case verguenza    = "Vergüenza"
    case enojo        = "Enojo"
    case ira          = "Ira"
    case tristeza     = "Tristeza"

    // Conformidad Identifiable (necesario para ForEach en SwiftUI)
    var id: String { rawValue }

    // ── Emoji representativo ─────────────────────────────────
    // EXTENSIBILIDAD: Cambia estos emojis para personalizar la
    // apariencia del selector de emociones.
    var emoji: String {
        switch self {
        case .alegria:      return "😊"
        case .curiosidad:   return "🤔"
        case .esperanza:    return "🌟"
        case .confianza:    return "💪"
        case .tranquilidad: return "😌"
        case .orgullo:      return "🏆"
        case .gratitud:     return "🙏"
        case .apatia:       return "😶"
        case .ansiedad:     return "😰"
        case .soledad:      return "🌧️"
        case .frustracion:  return "😤"
        case .verguenza:    return "😳"
        case .enojo:        return "😠"
        case .ira:          return "😡"
        case .tristeza:     return "😢"
        }
    }

    // ── Color representativo ─────────────────────────────────
    // EXTENSIBILIDAD: Estos colores se usarán en el futuro módulo
    // de gráficas de bienestar emocional. Puedes crear un Asset
    // Catalog con colores nombrados y referenciarlos con Color("nombre").
    var color: Color {
        switch self {
        case .alegria:      return Color(red: 1.0,  green: 0.80, blue: 0.10) // Amarillo cálido
        case .curiosidad:   return Color(red: 0.40, green: 0.60, blue: 1.0)  // Azul claro
        case .esperanza:    return Color(red: 0.30, green: 0.80, blue: 0.40) // Verde esperanza
        case .confianza:    return Color(red: 0.20, green: 0.70, blue: 0.90) // Azul confianza
        case .tranquilidad: return Color(red: 0.50, green: 0.85, blue: 0.75) // Verde menta
        case .orgullo:      return Color(red: 0.75, green: 0.45, blue: 0.95) // Morado
        case .gratitud:     return Color(red: 1.0,  green: 0.55, blue: 0.30) // Naranja cálido
        case .apatia:       return Color(red: 0.60, green: 0.60, blue: 0.60) // Gris
        case .ansiedad:     return Color(red: 1.0,  green: 0.65, blue: 0.20) // Naranja ansioso
        case .soledad:      return Color(red: 0.35, green: 0.45, blue: 0.70) // Azul oscuro
        case .frustracion:  return Color(red: 1.0,  green: 0.38, blue: 0.18) // Naranja-rojo
        case .verguenza:    return Color(red: 1.0,  green: 0.35, blue: 0.55) // Rosa
        case .enojo:        return Color(red: 0.90, green: 0.20, blue: 0.20) // Rojo enojo
        case .ira:          return Color(red: 0.65, green: 0.00, blue: 0.00) // Rojo oscuro ira
        case .tristeza:     return Color(red: 0.28, green: 0.38, blue: 0.80) // Azul tristeza
        }
    }

    // ── Categoría emocional ──────────────────────────────────
    // EXTENSIBILIDAD: Este dato se usará en el módulo de bienestar
    // para mostrar tendencias emocionales al usuario. Por ejemplo:
    // "Esta semana predominaron emociones negativas, ¿quieres hablar?"
    var category: EmotionCategory {
        switch self {
        case .alegria, .curiosidad, .esperanza, .confianza,
             .tranquilidad, .orgullo, .gratitud:
            return .positiva
        case .apatia:
            return .neutra
        case .ansiedad, .soledad, .frustracion,
             .verguenza, .enojo, .ira, .tristeza:
            return .negativa
        }
    }
}

// MARK: - Categoría emocional

/// Clasifica emociones en grupos para análisis futuros.
/// EXTENSIBILIDAD: Agrega `.ambigua` u otras categorías según necesites.
enum EmotionCategory: String, Codable {
    case positiva = "Positiva"
    case neutra   = "Neutra"
    case negativa = "Negativa"

    /// Color de fondo para representar la categoría en gráficas
    var color: Color {
        switch self {
        case .positiva: return .green
        case .neutra:   return .gray
        case .negativa: return .red
        }
    }
}
