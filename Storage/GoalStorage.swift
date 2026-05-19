// ============================================================
// Storage/GoalStorage.swift
// ============================================================

import Foundation

class GoalStorage {
    static let shared = GoalStorage()
    private init() {}

    private let activeGoalsFile = "goals_active.json"
    private let metaDataFile = "goals_metadata.json" // Nuevo archivo para rastreo de semanas
    
    struct GoalMetadata: Codable {
        var lastGeneratedWeekStart: Date
        var usedGoalTitles: [String] // Para no repetir metas
    }

    private var documentsURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    private var activeGoalsURL: URL? { documentsURL?.appendingPathComponent(activeGoalsFile) }
    private var metaDataURL: URL? { documentsURL?.appendingPathComponent(metaDataFile) }

    // MARK: - Metas activas
    func loadActiveGoals() -> [Goal] {
        guard let url = activeGoalsURL, let data = try? Data(contentsOf: url) else { return [] }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Goal].self, from: data)
        } catch { return [] }
    }

    func saveActiveGoals(_ goals: [Goal]) {
        guard let url = activeGoalsURL else { return }
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(goals)
            try data.write(to: url, options: .atomicWrite)
        } catch { print("Error guardando metas: \(error)") }
    }

    // MARK: - Metadata Semanal (Rotación)
    func loadMetadata() -> GoalMetadata? {
        guard let url = metaDataURL, let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(GoalMetadata.self, from: data)
    }
    
    func saveMetadata(_ metadata: GoalMetadata) {
        guard let url = metaDataURL else { return }
        if let data = try? JSONEncoder().encode(metadata) {
            try? data.write(to: url, options: .atomicWrite)
        }
    }
}

