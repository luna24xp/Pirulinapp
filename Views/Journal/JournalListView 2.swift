// ============================================================
// Views/Journal/JournalListView.swift
// Lista de todas las entradas del diario con opción de crear
// una nueva entrada.
//
// EXTENSIBILIDAD:
// - Para agregar búsqueda por texto: usa .searchable() en
//   NavigationView y filtra `diaryViewModel.entries` por el
//   término de búsqueda.
// - Para agregar filtros (por fecha, por emoción): agrega un
//   Picker o botones en el toolbar y aplica el filtro al
//   arreglo de entradas antes de mostrarlo.
// - Para agregar recordatorios locales: usa UNUserNotificationCenter
//   y programa una notificación diaria si `hasTodayEntry` es false.
// ============================================================

import SwiftUI

struct JournalListView: View {

    @EnvironmentObject var diaryViewModel:  DiaryViewModel
    // GoalsViewModel se inyecta desde DiaryApp.swift como environmentObject.
    // Permite que esta vista y GoalsSectionView compartan el mismo estado.
    @EnvironmentObject var goalsViewModel: GoalsViewModel

    // Controla si el sheet de nueva entrada está visible
    @State private var showingNewEntry: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                // PLACEHOLDER: Fondo personalizado de la pantalla del diario.
                // Para activar, reemplaza la línea de abajo:
                // Color("fondo_diario").ignoresSafeArea()

                if diaryViewModel.entries.isEmpty {
                    EmptyJournalView(onNewEntry: { showingNewEntry = true })
                } else {
                    entriesList
                }
            }
            .navigationTitle("Mi Diario")
            .toolbar {
                // Botón para abrir el flujo de nueva entrada
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewEntry = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }
                    .accessibilityLabel("Nueva entrada del diario")
                }

                // EXTENSIBILIDAD: Agrega aquí más botones al toolbar.
                // Ejemplo: botón de filtrar, ordenar, etc.
                // ToolbarItem(placement: .navigationBarLeading) { ... }
            }
            // Sheet con el flujo de 3 pasos para crear una nueva entrada
            .sheet(isPresented: $showingNewEntry) {
                NewEntryView()
                    .environmentObject(diaryViewModel)
            }
        }
        // StackNavigationViewStyle fuerza el comportamiento de iPhone
        // y evita que en iPad se use el layout de dos columnas.
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Lista de entradas

    private var entriesList: some View {
        List {
            // Sección de racha de días (motivación)
            if diaryViewModel.currentStreak > 1 {
                Section {
                    StreakBannerView(streak: diaryViewModel.currentStreak)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            // Sección principal de entradas
            Section {
                ForEach(diaryViewModel.entries) { entry in
                    // NavigationLink a la vista de detalle de cada entrada
                    NavigationLink(destination: EntryDetailView(entry: entry)) {
                        EntryRowView(entry: entry)
                    }
                }
                // Acción de eliminar deslizando hacia la izquierda
                .onDelete(perform: deleteEntries)
            } header: {
                Text("Entradas del diario")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // ── Sección de metas ─────────────────────────────
            // Recuadro de metas visible al final de la lista.
            //
            // EXTENSIBILIDAD:
            // - Para ocultar el recuadro hasta que haya al menos 1 entrada,
            //   envuelve este Section en: if !diaryViewModel.entries.isEmpty
            // - Para mover metas a su propia pestaña, elimina este Section
            //   y agrégalo en MainTabView.swift.
            Section {
                GoalsSectionView()
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            } header: {
                // ╔══════════════════════════════════════════════╗
                // ║  PLACEHOLDER TÍTULO SECCIÓN METAS           ║
                // ║  Cambia el texto para renombrar el header.  ║
                // ╚══════════════════════════════════════════════╝
                Text("Mi progreso")               // ← EDITAR título del grupo
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    // MARK: - Eliminar entradas

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            let entry = diaryViewModel.entries[index]
            diaryViewModel.deleteEntry(entry)
        }
    }
}

// MARK: - Fila de resumen de entrada

/// Vista compacta que representa una entrada en la lista del diario.
struct EntryRowView: View {

    let entry: DiaryEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            // Día de la semana + fecha
            HStack {
                Text(entry.weekdayName)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)
                    .textCase(.uppercase)

                Text("·")
                    .foregroundColor(.secondary)

                Text(entry.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                // Indicador de imágenes adjuntas
                if !entry.imageFileNames.isEmpty {
                    HStack(spacing: 3) {
                        Image(systemName: "photo")
                        Text("\(entry.imageFileNames.count)")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }

            // Preview del texto (máximo 2 líneas)
            Text(entry.textPreview)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(2)

            // Emociones del día como emojis
            HStack(spacing: 6) {
                ForEach(entry.emotions) { emotion in
                    Text(emotion.emoji)
                        .font(.body)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Banner de racha de días

/// Muestra la racha de días consecutivos con entrada.
/// EXTENSIBILIDAD: Conecta esto con un sistema de logros/recompensas.
struct StreakBannerView: View {

    let streak: Int

    var body: some View {
        HStack(spacing: 12) {
            // PLACEHOLDER: Reemplaza este ícono con una imagen personalizada de fuego
            // Image("icono_racha")
            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundColor(.orange)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(streak) días seguidos")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("¡Sigue así! 💪")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.orange.opacity(0.12))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

// MARK: - Vista de diario vacío

/// Se muestra cuando el usuario no tiene ninguna entrada todavía.
struct EmptyJournalView: View {

    let onNewEntry: () -> Void

    var body: some View {
        VStack(spacing: 20) {

            // PLACEHOLDER: Reemplaza este ícono con una ilustración personalizada.
            // Para activar imagen propia:
            // Image("ilustracion_diario_vacio")
            //     .resizable()
            //     .aspectRatio(contentMode: .fit)
            //     .frame(width: 220, height: 220)
            Image(systemName: "book.closed.fill")
                .font(.system(size: 80))
                .foregroundColor(.purple.opacity(0.35))

            Text("Tu diario está vacío")
                .font(.title2)
                .fontWeight(.bold)

            Text("Comienza escribiendo tu primer entrada.\nCada día importa 🌟")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: onNewEntry) {
                Label("Escribir primera entrada", systemImage: "pencil")
                    .fontWeight(.semibold)
                    .frame(maxWidth: 260)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding(.top, 8)
        }
        .padding(32)
    }
}
