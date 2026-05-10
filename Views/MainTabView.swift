// ============================================================
// Views/MainTabView.swift
// Vista raíz de la aplicación. Gestiona la navegación principal
// mediante una barra de pestañas (TabView).
//
// EXTENSIBILIDAD:
// Para agregar una nueva sección al menú (ej. Metas, Bienestar,
// Estadísticas, Perfil), sigue estos pasos:
//   1. Crea la vista nueva (ej. GoalsView.swift en Views/Goals/).
//   2. Agrega un Tab en el TabView con su Label y .tag correspondiente.
//   3. Crea el ViewModel si la sección lo necesita e inyéctalo como
//      @StateObject aquí o como @EnvironmentObject.
//
// NOTA: TabView en iOS muestra un botón "Más" cuando hay más de 5 tabs.
// Si superas 5 secciones, considera usar una NavigationSplitView
// o un menú lateral (sidebar) en su lugar.
// ============================================================

import SwiftUI

struct MainTabView: View {

    @EnvironmentObject var diaryViewModel: DiaryViewModel

    // Pestaña activa (0 = Diario, 1 = Galería, ...)
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            // ── Pestaña 1: Diario ────────────────────────────
            // Muestra la lista de entradas y permite crear nuevas.
            JournalListView()
                .tabItem {
                    // PLACEHOLDER: Para usar un ícono personalizado:
                    // Image("icono_diario")
                    // Text("Diario")
                    Label("Diario", systemImage: "book.fill")
                }
                .tag(0)

            // ── Pestaña 2: Galería ───────────────────────────
            // Muestra todas las imágenes añadidas a entradas del diario.
            GalleryView()
                .tabItem {
                    // PLACEHOLDER: Para usar un ícono personalizado:
                    // Image("icono_galeria")
                    // Text("Galería")
                    Label("Galería", systemImage: "photo.fill.on.rectangle.fill")
                }
                .tag(1)

            // ────────────────────────────────────────────────────────────────
            // EXTENSIBILIDAD – Agrega aquí nuevas pestañas para módulos futuros
            //
            // Ejemplo para el módulo de Metas:
            // GoalsView()
            //     .tabItem {
            //         Label("Metas", systemImage: "star.fill")
            //     }
            //     .tag(2)
            //
            // Ejemplo para el módulo de Bienestar / Estadísticas:
            // WellbeingView()
            //     .tabItem {
            //         Label("Bienestar", systemImage: "heart.fill")
            //     }
            //     .tag(3)
            //
            // Ejemplo para pantalla de Perfil / Configuración:
            // ProfileView()
            //     .tabItem {
            //         Label("Perfil", systemImage: "person.fill")
            //     }
            //     .tag(4)
            // ────────────────────────────────────────────────────────────────
        }
        // Color de acento de la barra de tabs y controles interactivos.
        // EXTENSIBILIDAD: Cambia este color para personalizar la paleta de la app.
        // También puedes definir un color en Assets.xcassets y referenciarlo con:
        // .tint(Color("ColorPrincipal"))
        .tint(Color.purple)
    }
}
