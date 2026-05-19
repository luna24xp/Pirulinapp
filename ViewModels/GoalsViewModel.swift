// ============================================================
// ViewModels/GoalsViewModel.swift
// Motor de análisis semanal y asignación de metas.
// ============================================================

import SwiftUI
import Combine

class GoalsViewModel: ObservableObject {

    @Published var activeGoals: [Goal] = []
    
    // Variables para la lógica semanal
    private var usedGoalTitles: [String] = []
    private var lastGeneratedWeekStart: Date?
    
    init() {
        loadState()
    }

    private func loadState() {
        activeGoals = GoalStorage.shared.loadActiveGoals()
        if let meta = GoalStorage.shared.loadMetadata() {
            lastGeneratedWeekStart = meta.lastGeneratedWeekStart
            usedGoalTitles = meta.usedGoalTitles
        }
    }

    // ============================================================
    // MARK: - LÓGICA PRINCIPAL: CHECK SEMANAL
    // Se llama desde la vista principal para comprobar si es lunes.
    // ============================================================
    
    func checkWeeklyRefresh(diaryEntries: [DiaryEntry]) {
        // 1. Calcular el lunes de la semana actual
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Lunes
        
        let now = Date()
        guard let currentWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else { return }
        
        // 2. Si ya estamos en la misma semana, no hacemos nada.
        if let last = lastGeneratedWeekStart, calendar.isDate(last, inSameDayAs: currentWeekStart) {
            // Si el usuario borró sus metas (array vacío por error), forzamos generación.
            if !activeGoals.isEmpty { return }
        }
        
        // 3. Es una NUEVA SEMANA. Generar nuevas metas.
        generateWeeklyGoals(weekStart: currentWeekStart, diaryEntries: diaryEntries)
    }
    
    // ============================================================
    // MARK: - GENERADOR DINÁMICO DE METAS
    // ============================================================
    
    private func generateWeeklyGoals(weekStart: Date, diaryEntries: [DiaryEntry]) {
        // A. Cuales fueron las metas no completadas? Se quedan.
        var newGoalsList = activeGoals.filter { !$0.isCompleted }
        
        // B. Calcular cuántos espacios hay disponibles
        let slotsToFill = 5 - newGoalsList.count
        guard slotsToFill > 0 else {
            saveMetadata(weekStart: weekStart) // No hay espacio, actualiza fecha y sale
            return
        }
        
        // C. Analizar emociones de la semana anterior
        let topGroups = analyzeLastWeekEmotions(entries: diaryEntries, currentWeekStart: weekStart)
        
        // D. Llenar los espacios vacíos con metas de esos grupos
        var neededPredefined = 0
        var neededFillers = 0
        
        // Por regla, siempre intentamos mantener 3 predefinidas y 2 fillers en total.
        let currentPredefined = newGoalsList.filter { $0.goalType == .predefined }.count
        let currentFillers = newGoalsList.filter { $0.goalType == .filler || $0.goalType == .custom }.count
        
        neededPredefined = max(0, 3 - currentPredefined)
        neededFillers = max(0, 2 - currentFillers)
        
        // Asignar nuevas predefinidas
        for i in 0..<neededPredefined {
            // Rotar a través de los grupos top
            let groupToPick = topGroups[i % topGroups.count]
            if let goalDef = pickUnusedGoal(from: groupToPick) {
                newGoalsList.append(createGoal(def: goalDef, type: .predefined, isCustomizable: false, order: newGoalsList.count))
            }
        }
        
        // Asignar nuevas fillers (personalizables) basadas en el top 2
        let fillerGroups = Array(topGroups.prefix(2))
        for i in 0..<neededFillers {
            let groupToPick = fillerGroups[i % fillerGroups.count]
            if let goalDef = pickUnusedGoal(from: groupToPick) {
                newGoalsList.append(createGoal(def: goalDef, type: .filler, isCustomizable: true, order: newGoalsList.count))
            }
        }
        
        // Aplicar y guardar
        self.activeGoals = newGoalsList
        saveMetadata(weekStart: weekStart)
        GoalStorage.shared.saveActiveGoals(self.activeGoals)
    }
    
    // ============================================================
    // MARK: - ANÁLISIS DE EMOCIONES
    // ============================================================
    
    private func analyzeLastWeekEmotions(entries: [DiaryEntry], currentWeekStart: Date) -> [EmotionGroup] {
        var groupCounts: [EmotionGroup: Int] = [:]
        
        // Filtrar entradas que pertenecen estrictamente a la semana anterior
        let lastWeekEntries = entries.filter { entry in
            entry.date < currentWeekStart && entry.date >= Calendar.current.date(byAdding: .day, value: -7, to: currentWeekStart)!
        }
        
        // Contar ocurrencias
        for entry in lastWeekEntries {
            for emotion in entry.emotions {
                groupCounts[EmotionGroup.group(for: emotion), default: 0] += 1
            }
        }
        
        // Si no escribió nada la semana pasada, damos metas Universales y de Bienestar
        if groupCounts.isEmpty {
            return [.universal, .bienestar, .exploracion]
        }
        
        // Ordenar grupos de mayor a menor frecuencia
        let sortedGroups = groupCounts.sorted { $0.value > $1.value }.map { $0.key }
        
        // Devolver los top 3 (o menos si solo sintió 1 o 2 grupos)
        return Array(sortedGroups.prefix(3))
    }
    
    // ============================================================
    // MARK: - HELPERS
    // ============================================================
    
    private func pickUnusedGoal(from group: EmotionGroup) -> GoalDefinition? {
        guard let definitions = GoalSets.goalsByGroup[group] else { return nil }
        
        // Filtrar metas no usadas
        let available = definitions.filter { !usedGoalTitles.contains($0.title) }
        
        // Si ya usó todas las de ese grupo, limpiamos el historial para rotar de nuevo
        if available.isEmpty {
            usedGoalTitles.removeAll { title in definitions.contains(where: { $0.title == title }) }
            let refreshedAvailable = definitions.filter { !usedGoalTitles.contains($0.title) }
            let picked = refreshedAvailable.randomElement()
            if let picked = picked { usedGoalTitles.append(picked.title) }
            return picked
        }
        
        // Elegir una al azar
        let picked = available.randomElement()!
        usedGoalTitles.append(picked.title)
        return picked
    }
    
    private func createGoal(def: GoalDefinition, type: GoalType, isCustomizable: Bool, order: Int) -> Goal {
        return Goal(
            phase: 1, // La fase ya no importa tanto, el motor manda
            displayOrder: order,
            title: def.title,
            description: def.description,
            goalType: type,
            isCustomizable: isCustomizable
        )
    }

    private func saveMetadata(weekStart: Date) {
        lastGeneratedWeekStart = weekStart
        let meta = GoalStorage.GoalMetadata(lastGeneratedWeekStart: weekStart, usedGoalTitles: usedGoalTitles)
        GoalStorage.shared.saveMetadata(meta)
    }

    // ============================================================
    // MÉTODOS DE LA UI (Conservados)
    // ============================================================
    
    func toggleGoalCompletion(_ goal: Goal) {
        guard let idx = activeGoals.firstIndex(where: { $0.id == goal.id }) else { return }
        activeGoals[idx].isCompleted.toggle()
        activeGoals[idx].completedDate = activeGoals[idx].isCompleted ? Date() : nil
        GoalStorage.shared.saveActiveGoals(activeGoals)
    }

    func replaceFillerWithCustomGoal(goalId: UUID, title: String, description: String) {
        guard let idx = activeGoals.firstIndex(where: { $0.id == goalId }), activeGoals[idx].isCustomizable else { return }
        let customGoal = Goal(
            phase: 1,
            displayOrder: activeGoals[idx].displayOrder,
            title: title,
            description: description,
            goalType: .custom,
            isCustomizable: false
        )
        activeGoals[idx] = customGoal
        GoalStorage.shared.saveActiveGoals(activeGoals)
    }
    
    var completedCount: Int { activeGoals.filter { $0.isCompleted }.count }
    var progressFraction: Double { activeGoals.isEmpty ? 0 : Double(completedCount) / Double(activeGoals.count) }
    var remainingCustomSlots: Int { activeGoals.filter { $0.goalType == .filler && $0.isCustomizable }.count }
    var hasCustomizableSlots: Bool { remainingCustomSlots > 0 }
    
    // NOTA: isTransitioningPhase y currentPhase se pueden borrar o mantener para evitar romper vistas,
    // pero ya no son necesarios en el motor principal.
    @Published var isTransitioningPhase: Bool = false
    @Published var currentPhase: Int = 1
}

