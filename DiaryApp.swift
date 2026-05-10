// ============================================================
// DiaryApp.swift
// Punto de entrada principal de la aplicación.
//
// EXTENSIBILIDAD:
// - Para agregar onboarding (primera vez que se abre la app),
//   revisa si es el primer lanzamiento aquí con @AppStorage
//   y presenta una vista de bienvenida antes del MainTabView.
// - Para agregar autenticación (Face ID / PIN), intercálala
//   aquí antes de mostrar MainTabView.
// ============================================================

import SwiftUI

@main
struct DiaryApp: App {

    // DiaryViewModel es el ViewModel compartido para toda la app.
    // Al declararlo con @StateObject aquí, vive todo el ciclo de vida de la app.
    // Se propaga a todas las vistas descendientes como environmentObject.
    @StateObject private var diaryViewModel = DiaryViewModel()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(diaryViewModel)
        }
    }
}
