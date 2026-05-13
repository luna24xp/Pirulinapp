// ============================================================
// Models/Goal.swift
// Ruta: DiaryApp/Models/Goal.swift
//
// Define la estructura de datos de UNA meta y el enum que
// clasifica su tipo. Es el núcleo del módulo de metas.
//
// EXTENSIBILIDAD:
// - Para vincular metas con entradas del diario, agrega:
//     var linkedEntryIds: [UUID] = []
// - Para agregar fechas límite (deadline), agrega:
//     var dueDate: Date?
// - Para agregar niveles de dificultad, agrega:
//     var difficulty: GoalDifficulty = .media
//   y crea el enum GoalDifficulty debajo de GoalType.
// - Para el módulo de estadísticas, usa `completedDate` y
//   `phase` para calcular cuánto tardó el usuario en completar
//   cada fase, y compara con promedios.
// ============================================================

import Foundation

// MARK: - Tipo de meta

/// Clasifica el origen y comportamiento de cada meta.
///
/// EXTENSIBILIDAD: Agrega casos según necesites.
/// Ejemplo: `.challenge` para retos especiales de tiempo limitado.
enum GoalType: String, Codable {

    /// Meta definida fija por el sistema. No puede ser reemplazada.
    case predefined

    /// Meta creada por el propio usuario para reemplazar un slot de relleno.
    case custom

    /// Meta de relleno automático: ocupa un slot vacío que el usuario
    /// no personalizó. Puede ser reemplazada por una meta custom.
    case filler
}

// MARK: - Modelo de meta

struct Goal: Codable, Identifiable {

    // ── Identificación ───────────────────────────────────────
    var id:           UUID = UUID()   // Clave única de la meta
    var phase:        Int             // Fase a la que pertenece (1, 2, 3...)
    var displayOrder: Int             // Posición en la lista (0-based)

    // ── Contenido ────────────────────────────────────────────

    // ╔══════════════════════════════════════════════════════╗
    // ║  Para cambiar títulos y descripciones de metas,     ║
    // ║  NO edites estos campos aquí.                       ║
    // ║  Edítalos en: Goals/GoalSets.swift                  ║
    // ╚══════════════════════════════════════════════════════╝
    var title:       String   // Título corto de la meta (máx. ~40 chars recomendado)
    var description: String   // Descripción detallada de cómo cumplir la meta

    // ── Tipo y comportamiento ────────────────────────────────
    var goalType:      GoalType         // predefined | custom | filler
    var isCustomizable: Bool = false    // true = el usuario puede reemplazar esta meta
                                        // Solo true para metas de tipo .filler en fase ≥ 2

    // ── Estado de progreso ───────────────────────────────────
    var isCompleted:   Bool  = false    // ¿La meta fue marcada como completada?
    var completedDate: Date? = nil      // Fecha en que se completó (nil si no completada)
    var createdDate:   Date  = Date()   // Fecha en que se agregó esta meta al ciclo

    // ── Propiedades calculadas ───────────────────────────────

    /// Fecha de completado formateada en español. Nil si no completada.
    /// EXTENSIBILIDAD: Usar en una futura vista de historial de metas.
    var formattedCompletedDate: String? {
        guard let date = completedDate else { return nil }
        let formatter        = DateFormatter()
        formatter.dateStyle  = .medium
        formatter.locale     = Locale(identifier: "es_MX")
        return formatter.string(from: date)
    }

    /// Preview corto del título (máx. 35 chars) para vistas compactas.
    var titlePreview: String {
        title.count > 35 ? String(title.prefix(35)) + "..." : title
    }
}
