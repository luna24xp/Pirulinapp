// ============================================================
// Views/Journal/JournalListView.swift
// Lista de todas las entradas del diario con opción de crear
// una nueva entrada.
// ============================================================

import SwiftUI

struct JournalListView: View {

    @EnvironmentObject var diaryViewModel:  DiaryViewModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel

    @State private var showingNewEntry: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                if diaryViewModel.entries.isEmpty {
                    EmptyJournalView(onNewEntry: { showingNewEntry = true })
                } else {
                    entriesList
                }
            }
            .navigationTitle("Mi Diario")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewEntry = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }
                    .accessibilityLabel("Nueva entrada del diario")
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                NewEntryView()
                    .environmentObject(diaryViewModel)
            }
            // ⬇️ ESTA ES LA LÍNEA NUEVA AÑADIDA ⬇️
            .onAppear {
                goalsViewModel.checkWeeklyRefresh(diaryEntries: diaryViewModel.entries)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Lista de entradas
    private var entriesList: some View {
        List {
            if diaryViewModel.currentStreak > 1 {
                Section {
                    StreakBannerView(streak: diaryViewModel.currentStreak)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            Section {
                ForEach(diaryViewModel.entries) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry)) {
                        EntryRowView(entry: entry)
                    }
                }
                .onDelete(perform: deleteEntries)
            } header: {
                Text("Entradas del diario")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Section {
                GoalsSectionView()
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            } header: {
                Text("Mi progreso")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            let entry = diaryViewModel.entries[index]
            diaryViewModel.deleteEntry(entry)
        }
    }
}

// MARK: - Fila de resumen de entrada
struct EntryRowView: View {
    let entry: DiaryEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(entry.weekdayName).font(.caption).fontWeight(.semibold).foregroundColor(.purple).textCase(.uppercase)
                Text("·").foregroundColor(.secondary)
                Text(entry.formattedDate).font(.caption).foregroundColor(.secondary)
                Spacer()
                if !entry.imageFileNames.isEmpty {
                    HStack(spacing: 3) {
                        Image(systemName: "photo")
                        Text("\(entry.imageFileNames.count)")
                    }.font(.caption).foregroundColor(.secondary)
                }
            }
            Text(entry.textPreview).font(.subheadline).foregroundColor(.primary).lineLimit(2)
            HStack(spacing: 6) {
                ForEach(entry.emotions) { emotion in
                    Text(emotion.emoji).font(.body)
                }
            }
        }.padding(.vertical, 4)
    }
}

// MARK: - Banner de racha de días
struct StreakBannerView: View {
    let streak: Int
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "flame.fill").font(.title2).foregroundColor(.orange)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(streak) días seguidos").font(.subheadline).fontWeight(.semibold)
                Text("¡Sigue así! 💪").font(.caption).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding().background(Color.orange.opacity(0.12)).cornerRadius(12).padding(.horizontal).padding(.vertical, 4)
    }
}

// MARK: - Vista de diario vacío
struct EmptyJournalView: View {
    let onNewEntry: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed.fill").font(.system(size: 80)).foregroundColor(.purple.opacity(0.35))
            Text("Tu diario está vacío").font(.title2).fontWeight(.bold)
            Text("Comienza escribiendo tu primer entrada.\nCada día importa 🌟").font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center)
            Button(action: onNewEntry) {
                Label("Escribir primera entrada", systemImage: "pencil")
                    .fontWeight(.semibold).frame(maxWidth: 260).padding().background(Color.purple).foregroundColor(.white).cornerRadius(14)
            }.padding(.top, 8)
        }.padding(32)
    }
}

