// DiaryApp.swift                          ← VERSIÓN ACTUALIZADA
// Ruta: DiaryApp/DiaryApp.swift
//
// Punto de entrada principal de la aplicación.
// Esta es la ÚNICA modificación a archivos existentes que
// requiere el módulo de onboarding.
//
// CAMBIOS RESPECTO A LA VERSIÓN ANTERIOR:
//   + Se agrega @AppStorage("hasCompletedOnboarding") para
//     detectar si el usuario ya vio el onboarding.
//   + La vista raíz ahora usa un ZStack con transición:
//       → Primera vez: muestra OnboardingView
//       → Siguientes veces: muestra MainTabView directamente
//
// CÓMO FUNCIONA EL FLUJO:
//   1. La app arranca → DiaryApp lee @AppStorage.
//   2. Si hasCompletedOnboarding == false → muestra OnboardingView.
//   3. El usuario llega a la face 5 y presiona "¡Comenzar!" (o "Saltar").
//   4. OnboardingView.completeOnboarding() pone
//      hasCompletedOnboarding = true en UserDefaults.
//   5. DiaryApp detecta el cambio (SwiftUI reactivo) y reemplaza
//      OnboardingView con MainTabView con una transición animada.
//   6. En todos los arranques posteriores, hasCompletedOnboarding
//      ya es true, así que MainTabView aparece directamente.
//
// PARA RESETEAR EL ONBOARDING (útil en desarrollo/pruebas):
//   Opción A: En el simulador → Hardware → Erase All Content
//   Opción B: Agrega temporalmente este código en init():
//             UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
//   Opción C: Agrega un botón "Reset onboarding" en Configuración
//             que llame a: hasCompletedOnboarding = false
//
// EXTENSIBILIDAD:
// - Para onboarding por versión (mostrar novedad en actualizaciones),
//   usa @AppStorage("onboardingVersion") y compara con la versión
//   actual. Si es menor, muestra un mini-onboarding de novedades.
// - Para autenticación (Face ID / PIN), intercálala dentro del
//   bloque `if hasCompletedOnboarding { }` para que aparezca
//   solo después del onboarding y en cada inicio posterior.
// ============================================================
 
import SwiftUI
 
@main
struct DiaryApp: App {
 
    // ── ViewModel compartido en toda la app ──────────────────
    // Declarado aquí para que viva todo el ciclo de vida de la app.
    // Se propaga mediante .environmentObject() a todas las vistas.
    @StateObject private var diaryViewModel = DiaryViewModel()
 
    // ── ViewModel de metas ───────────────────────────────────
    // Declarado junto a DiaryViewModel para que ambos compartan
    // el mismo ciclo de vida de la app.
    // EXTENSIBILIDAD: Si necesitas un ViewModel más (ej. WellbeingViewModel),
    // agrégalo aquí con el mismo patrón @StateObject.
    @StateObject private var goalsViewModel = GoalsViewModel()
 
    // ── Persistencia del estado del onboarding ───────────────
    // @AppStorage lee y escribe en UserDefaults automáticamente.
    // La clave "hasCompletedOnboarding" debe coincidir exactamente
    // con la usada en OnboardingView.swift.
    //
    // Valor inicial: false → la primera vez siempre muestra onboarding.
    // Después de completarlo: true → nunca más se muestra.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
 
    // MARK: - Scene
 
    var body: some Scene {
        WindowGroup {
            ZStack {
                if hasCompletedOnboarding {
                    // ── Flujo normal: app completa ────────────
                    // El usuario ya completó el onboarding en una
                    // sesión anterior. Se muestra la app directamente.
                    MainTabView()
                        .environmentObject(diaryViewModel)
                        .environmentObject(goalsViewModel)   // ← Propagación del ViewModel de metas
                        .transition(.asymmetric(
                            insertion:  .move(edge: .trailing),
                            removal:    .opacity
                        ))
 
                } else {
                    // ── Primer inicio: pantalla de bienvenida ─
                    // Solo se muestra UNA vez en la vida de la app.
                    // OnboardingView gestiona su propio @AppStorage
                    // para marcar cuándo termina.
                    OnboardingView()
                        .transition(.asymmetric(
                            insertion:  .opacity,
                            removal:    .move(edge: .leading)
                        ))
                }
            }
            // Animación que envuelve el cambio completo del ZStack,
            // produciendo la transición suave entre OnboardingView
            // y MainTabView cuando hasCompletedOnboarding cambia a true.
            .animation(.easeInOut(duration: 0.45), value: hasCompletedOnboarding)
        }
    }
}
 
