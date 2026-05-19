// ============================================================
// Views/Onboarding/OnboardingView.swift
// Ruta: DiaryApp/Views/Onboarding/OnboardingView.swift
//
// Controladora principal de la pantalla de inicio (onboarding).
// Responsabilidades:
//   • Cargar las faces desde OnboardingContent.pages
//   • Mostrarlas en un TabView paginado (deslizable)
//   • Gestionar el estado de la face activa
//   • Mostrar el indicador de puntos (dots) de progreso
//   • Mostrar el botón "Siguiente" / "¡Comenzar!" según la face
//   • Marcar el onboarding como completado en @AppStorage
//     para que NO se vuelva a mostrar al relanzar la app
//
// EXTENSIBILIDAD:
// - Para agregar una animación de salida personalizada al completar
//   el onboarding, modifica la función `completeOnboarding()`.
// - Para agregar lógica de "saltar onboarding" (skip), agrega un
//   botón en el toolbar que llame a `completeOnboarding()` directamente.
// - Para añadir un sonido al pasar de face, usa AVFoundation
//   o el paquete AudioToolbox dentro de `goToNextPage()`.
// ============================================================

import SwiftUI

struct OnboardingView: View {

    // ── Enlace con AppStorage ────────────────────────────────
    // Esta variable persiste en UserDefaults bajo la clave
    // "hasCompletedOnboarding". Cuando es true, DiaryApp.swift
    // ya no presenta esta vista. Es la única dependencia hacia
    // el exterior de este módulo.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    // ── Estado interno ───────────────────────────────────────

    /// Índice de la face actualmente visible (0-based).
    /// TabView lo gestiona bidireccionalmente con el binding.
    @State private var currentPageIndex: Int = 0

    /// Faces del onboarding. Se carga una sola vez desde OnboardingContent.
    /// Para cambiar el contenido, edita OnboardingContent.swift.
    private let pages: [OnboardingPage] = OnboardingContent.pages

    // ── Color de acento de la face activa ───────────────────
    // Propiedad calculada: cambia dinámicamente con la face.
    private var activeAccentColor: Color {
        guard currentPageIndex < pages.count else { return .purple }
        return pages[currentPageIndex].accentColor
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {

            // ── Botón "Saltar" en la esquina superior derecha ──
            // EXTENSIBILIDAD: Para ocultar el botón en ciertas faces,
            // agrega: .opacity(pages[currentPageIndex].isLastPage ? 0 : 1)
            HStack {
                Spacer()
                Button("Saltar") {
                    completeOnboarding()
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 16)
                .padding(.trailing, 20)
            }

            // ── Carrusel de faces ────────────────────────────
            // TabView con estilo .page crea el efecto de swipe
            // horizontal entre faces. El binding a currentPageIndex
            // mantiene sincronizado el indicador de puntos.
            //
            // NOTA TÉCNICA: .tabViewStyle(.page(indexDisplayMode: .never))
            // oculta los dots nativos de iOS para usar los propios (abajo).
            TabView(selection: $currentPageIndex) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)           // Necesario para que el binding funcione
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            // Transición animada al cambiar de face
            .animation(.easeInOut(duration: 0.3), value: currentPageIndex)

            // ── Indicador de puntos (dots) ───────────────────
            PageDotsIndicatorView(
                totalPages:   pages.count,
                currentPage:  currentPageIndex,
                accentColor:  activeAccentColor
            )
            .padding(.top, 12)

            // ── Botón de navegación ──────────────────────────
            navigationButton
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 40)
        }
        // Animar el cambio de color de acento entre faces
        .animation(.easeInOut(duration: 0.35), value: currentPageIndex)
    }

    // =========================================================
    // MARK: - Botón de navegación (Siguiente / ¡Comenzar!)
    // =========================================================

    @ViewBuilder
    private var navigationButton: some View {

        let isLastPage = pages[currentPageIndex].isLastPage

        Button(action: {
            if isLastPage {
                completeOnboarding()
            } else {
                goToNextPage()
            }
        }) {
            HStack(spacing: 8) {
                // ╔══════════════════════════════════════════╗
                // ║  PLACEHOLDER DE TEXTO DEL BOTÓN          ║
                // ║  Para cambiar el texto de los botones,   ║
                // ║  edita las cadenas en las líneas de      ║
                // ║  "Siguiente" y "¡Comenzar!" aquí abajo. ║
                // ╚══════════════════════════════════════════╝
                Text(isLastPage ? "¡Comenzar!" : "Siguiente")  // ← EDITAR AQUÍ
                    .fontWeight(.semibold)
                    .font(.body)

                if !isLastPage {
                    Image(systemName: "arrow.right")
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(activeAccentColor)
            .foregroundColor(.white)
            .cornerRadius(16)
            // Sombra del botón con el color de acento
            .shadow(color: activeAccentColor.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }

    // =========================================================
    // MARK: - Acciones
    // =========================================================

    /// Avanza a la siguiente face con animación suave.
    private func goToNextPage() {
        guard currentPageIndex < pages.count - 1 else { return }
        withAnimation(.easeInOut(duration: 0.35)) {
            currentPageIndex += 1
        }
    }

    /// Marca el onboarding como completado.
    /// Esto actualiza @AppStorage → DiaryApp.swift detecta el cambio
    /// y reemplaza OnboardingView con MainTabView automáticamente.
    ///
    /// EXTENSIBILIDAD: Agrega aquí cualquier lógica de cierre:
    ///   - Animación de transición personalizada
    ///   - Llamada a un API para registrar que el usuario completó el tutorial
    ///   - Solicitar permisos de notificaciones al terminar el onboarding
    private func completeOnboarding() {
        // withAnimation produce la transición visual suave hacia MainTabView
        withAnimation(.easeInOut(duration: 0.4)) {
            hasCompletedOnboarding = true
        }
    }
}

// =========================================================
// MARK: - Indicador de puntos de progreso
// =========================================================

/// Muestra una fila de círculos que indican cuántas faces hay
/// y cuál es la activa. El punto activo tiene el color de acento
/// de la face actual; los inactivos son grises.
///
/// EXTENSIBILIDAD:
/// - Para un estilo de "barra" en lugar de puntos, reemplaza los
///   dos Circle() por RoundedRectangle() con .frame(width:, height:)
///   distinto para el activo y los inactivos.
/// - Para agregar transición animada al punto activo (ej. que se
///   deslice), usa matchedGeometryEffect.
struct PageDotsIndicatorView: View {

    let totalPages:  Int
    let currentPage: Int
    let accentColor: Color

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in

                let isActive = index == currentPage

                // ╔══════════════════════════════════════════╗
                // ║  PLACEHOLDER DE INDICADOR DE PUNTOS      ║
                // ║  Para cambiar el estilo de los puntos,   ║
                // ║  modifica el tamaño, forma o colores     ║
                // ║  en las líneas de abajo.                 ║
                // ╚══════════════════════════════════════════╝
                Circle()
                    // FÁCIL DE CAMBIAR: tamaños del punto activo vs inactivo
                    .frame(
                        width:  isActive ? 10 : 7,
                        height: isActive ? 10 : 7
                    )
                    // FÁCIL DE CAMBIAR: colores
                    .foregroundColor(
                        isActive
                        ? accentColor               // ← punto activo: color de la face
                        : Color(.systemGray4)        // ← puntos inactivos: gris
                    )
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
            }
        }
    }
}
