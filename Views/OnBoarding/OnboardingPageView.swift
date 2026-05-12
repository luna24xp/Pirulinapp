// ============================================================
// Views/Onboarding/OnboardingPageView.swift
// Ruta: DiaryApp/Views/Onboarding/OnboardingPageView.swift
//
// Renderiza visualmente UNA face del onboarding a partir de
// los datos de un OnboardingPage. Esta vista es genérica:
// no sabe cuál face específica está mostrando, solo recibe
// datos y los despliega. Eso la hace completamente reutilizable.
//
// EXTENSIBILIDAD:
// - Para agregar un nuevo tipo de layout (ej. imagen a la izquierda
//   con texto a la derecha), agrega un caso al enum `PageLayout`
//   y un @ViewBuilder que lo renderice.
// - Para soportar video en lugar de imagen, agrega VideoPlayer de
//   AVKit como opción en imageSection() y añade una propiedad
//   videoURL: URL? al modelo OnboardingPage.
// - Para agregar animaciones de entrada por face, usa
//   .transition() y .animation() combinados con el índice de
//   la face actual que viene de OnboardingView.
// ============================================================

import SwiftUI

struct OnboardingPageView: View {

    // Datos de la face que esta vista debe renderizar.
    // Viene de OnboardingContent.pages[índice].
    let page: OnboardingPage

    // MARK: - Body

    var body: some View {
        // ScrollView permite que el contenido no se corte en
        // iPhones pequeños (SE, mini) cuando hay mucho texto.
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {

                // ── Zona superior: ícono o imagen ────────────
                imageSection
                    .padding(.bottom, 32)

                // ── Zona central: textos ─────────────────────
                textSection
                    .padding(.horizontal, 28)

                // ── Zona de lista (si tiene bullet points) ───
                if page.hasBulletPoints {
                    bulletPointsSection
                        .padding(.horizontal, 28)
                        .padding(.top, 24)
                }

                // Espacio inferior para que el contenido no quede
                // pegado al indicador de puntos de OnboardingView
                Spacer(minLength: 60)
            }
            .padding(.top, 40)
        }
    }

    // =========================================================
    // MARK: - Sección de imagen / ícono
    // =========================================================

    @ViewBuilder
    private var imageSection: some View {

        // ── Caso 1: imagen personalizada desde Assets.xcassets ──
        // Se activa cuando imageName no es nil Y el asset existe.
        if let imageName = page.imageName, UIImage(named: imageName) != nil {

            // ╔══════════════════════════════════════════════╗
            // ║  PLACEHOLDER DE IMAGEN PERSONALIZADA         ║
            // ║                                              ║
            // ║  Esta sección muestra tu imagen de asset.   ║
            // ║  Para ajustar tamaño o modo de ajuste,      ║
            // ║  modifica .frame() y contentMode abajo.     ║
            // ╚══════════════════════════════════════════════╝
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                // FÁCIL DE CAMBIAR: ajusta el ancho máximo de la imagen
                .frame(maxWidth: 280, maxHeight: 280)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                // FÁCIL DE CAMBIAR: comenta/descomentar sombra
                // .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)

        } else {
            // ── Caso 2: SF Symbol de respaldo ───────────────
            // Se muestra cuando no hay imagen personalizada.
            // EXTENSIBILIDAD: Reemplaza este bloque con
            // cualquier ilustración SVG/Shape personalizada.

            ZStack {
                // Círculo de fondo con el color de acento de la face
                Circle()
                    .fill(page.accentColor.opacity(0.12))
                    .frame(width: 180, height: 180)

                // ╔══════════════════════════════════════════╗
                // ║  PLACEHOLDER DE SF SYMBOL                ║
                // ║                                          ║
                // ║  El ícono viene de symbolName en         ║
                // ║  OnboardingContent.swift.                ║
                // ║  Busca íconos en la app SF Symbols.      ║
                // ╚══════════════════════════════════════════╝
                Image(systemName: page.symbolName)
                    // FÁCIL DE CAMBIAR: tamaño del ícono SF Symbol
                    .font(.system(size: 72, weight: .medium))
                    .foregroundColor(page.symbolColor)
            }
        }
    }

    // =========================================================
    // MARK: - Sección de texto
    // =========================================================

    private var textSection: some View {
        VStack(alignment: .center, spacing: 14) {

            // ── Título principal ─────────────────────────────
            // ╔══════════════════════════════════════════════╗
            // ║  PLACEHOLDER DE TÍTULO                       ║
            // ║  Editar en: OnboardingContent.swift          ║
            // ║  Propiedad: title: "..."                     ║
            // ╚══════════════════════════════════════════════╝
            Text(page.title)
                // FÁCIL DE CAMBIAR: .largeTitle, .title, .title2, etc.
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                // FÁCIL DE CAMBIAR: color del título
                // .foregroundColor(page.accentColor)

            // ── Subtítulo ────────────────────────────────────
            // ╔══════════════════════════════════════════════╗
            // ║  PLACEHOLDER DE SUBTÍTULO                    ║
            // ║  Editar en: OnboardingContent.swift          ║
            // ║  Propiedad: subtitle: "..."                  ║
            // ╚══════════════════════════════════════════════╝
            Text(page.subtitle)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(page.accentColor)
                .multilineTextAlignment(.center)

            // ── Cuerpo de texto ──────────────────────────────
            // ╔══════════════════════════════════════════════╗
            // ║  PLACEHOLDER DE CUERPO                       ║
            // ║  Editar en: OnboardingContent.swift          ║
            // ║  Propiedad: body: "..."                      ║
            // ╚══════════════════════════════════════════════╝
            Text(page.body)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // =========================================================
    // MARK: - Sección de bullet points
    // =========================================================

    private var bulletPointsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(page.bulletPoints.indices, id: \.self) { index in
                let point = page.bulletPoints[index]

                // ── Fila de bullet point ─────────────────────
                // ╔══════════════════════════════════════════╗
                // ║  PLACEHOLDER DE BULLET POINTS            ║
                // ║  Editar en: OnboardingContent.swift      ║
                // ║  Propiedad: bulletPoints: [(emoji, texto)]║
                // ╚══════════════════════════════════════════╝
                HStack(alignment: .firstTextBaseline, spacing: 14) {

                    // Emoji o ícono del punto
                    Text(point.emoji)
                        .font(.title3)
                        .frame(width: 30, alignment: .center)

                    // Texto del punto
                    Text(point.text)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(page.accentColor.opacity(0.08))
                )
            }
        }
    }
}
