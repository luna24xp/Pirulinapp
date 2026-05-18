// ============================================================
// Models/EmotionGroup.swift
// Mapea las emociones individuales a los grupos psicológicos.
// ============================================================

import Foundation

enum EmotionGroup: Int, CaseIterable {
    case bienestar = 1    // Alegría, Tranquilidad, Gratitud, Confianza
    case exploracion = 2  // Curiosidad, Esperanza, Orgullo
    case defensa = 3      // Enojo, Frustración, Ira
    case repliegue = 4    // Tristeza, Soledad, Vergüenza
    case alerta = 5       // Ansiedad, Apatía
    case universal = 0    // Metas de apoyo constante
    
    /// Devuelve el grupo correspondiente para una emoción específica.
    static func group(for emotion: Emotion) -> EmotionGroup {
        switch emotion {
        case .alegria, .tranquilidad, .gratitud, .confianza:
            return .bienestar
        case .curiosidad, .esperanza, .orgullo:
            return .exploracion
        case .enojo, .frustracion, .ira:
            return .defensa
        case .tristeza, .soledad, .verguenza:
            return .repliegue
        case .ansiedad, .apatia:
            return .alerta
        }
    }
}
