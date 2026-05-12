// ============================================================
// Models/OnboardingPage.swift
// Ruta: DiaryApp/Models/OnboardingPage.swift
//
// Define la estructura de datos que describe UNA face (página)
// dentro de la pantalla de inicio (onboarding). Cada face se
// construye a partir de este modelo y se renderiza de forma
// uniforme en OnboardingPageView.
//
// ── CÓMO AGREGAR UNA NUEVA FACE ─────────────────────────────
//   1. Ve a OnboardingContent.swift
//   2. Agrega un nuevo OnboardingPage(...) al arreglo `pages`
//   3. Listo. No necesitas tocar este archivo ni OnboardingView.
//
// ── CÓMO QUITAR UNA FACE ────────────────────────────────────
//   1. Ve a OnboardingContent.swift
//   2. Elimina el OnboardingPage(...) correspondiente del arreglo
//   3. Listo.
//
// EXTENSIBILIDAD:
// - Para agregar campos nuevos a una face (ej. un video, un
//   botón de acción personalizado, un quiz), agrega la propiedad
//   aquí con un valor por defecto (nil o false) para mantener
//   compatibilidad con las faces existentes.
// - Para soportar subfaces animadas dentro de una face, agrega
//   un arreglo de sub-contenido como propiedad opcional.
// ============================================================

import SwiftUI

// MARK: - Modelo de Face (página del onboarding)

struct OnboardingPage: Identifiable {

    // ── Identificador ────────────────────────────────────────
    /// ID único. Se genera automáticamente; no necesitas asignarlo.
    var id: UUID = UUID()

    // =========================================================
    // ── ZONA DE IMAGEN ────────────────────────────────────────
    // =========================================================
    //
    // imageName: nombre de un asset en Assets.xcassets.
    //            Si es nil, se muestra el SF Symbol de `symbolName`.
    //
    // CÓMO AGREGAR TU IMAGEN PERSONALIZADA:
    //   1. Arrastra tu imagen a Assets.xcassets en Xcode.
    //   2. Dale un nombre (ej. "onboarding_bienvenida").
    //   3. En OnboardingContent.swift, escribe ese nombre aquí:
    //      imageName: "onboarding_bienvenida"
    //   4. Pon symbolName en nil para que no aparezca el ícono.
    //
    // =========================================================
    var imageName: String? = nil         // Nombre del asset personalizado

    // symbolName: SF Symbol de respaldo cuando no hay imagen.
    //             Puedes buscar íconos en la app "SF Symbols" de Apple.
    var symbolName: String = "star.fill" // SF Symbol de respaldo

    // symbolColor: color del SF Symbol cuando no hay imagen.
    //              FÁCIL DE CAMBIAR: usa cualquier Color de SwiftUI.
    var symbolColor: Color = .purple

    // =========================================================
    // ── ZONA DE TEXTO ─────────────────────────────────────────
    // =========================================================
    //
    // Todos los textos se editan directamente en OnboardingContent.swift.
    // Los nombres de propiedades son descriptivos para facilitar la edición.
    //
    // =========================================================

    /// Título principal grande de la face.
    /// EDITAR EN: OnboardingContent.swift → title: "Tu texto aquí"
    var title: String

    /// Subtítulo o frase corta debajo del título.
    /// EDITAR EN: OnboardingContent.swift → subtitle: "Tu texto aquí"
    var subtitle: String

    /// Descripción larga / cuerpo de texto de la face.
    /// Puede contener saltos de línea con \n.
    /// EDITAR EN: OnboardingContent.swift → body: "Tu texto aquí"
    var body: String

    // =========================================================
    // ── ZONA DE PERSONALIZACIÓN VISUAL ───────────────────────
    // =========================================================

    /// Color de acento de esta face individual.
    /// Afecta el indicador de punto activo y detalles visuales.
    /// FÁCIL DE CAMBIAR: Color.pink, Color.teal, Color.orange, etc.
    var accentColor: Color = .purple

    /// ¿Esta face muestra una lista de puntos clave (bullet points)?
    /// Si true, el texto de `bulletPoints` se muestra como lista visual.
    var hasBulletPoints: Bool = false

    /// Puntos clave que se muestran si `hasBulletPoints` es true.
    /// Cada elemento es una tupla (emoji, texto).
    ///
    /// EDITAR EN: OnboardingContent.swift
    /// EJEMPLO: bulletPoints: [("📖", "Escribe tu día"), ("😊", "Registra emociones")]
    var bulletPoints: [(emoji: String, text: String)] = []

    // =========================================================
    // ── ZONA DEL BOTÓN FINAL ──────────────────────────────────
    // =========================================================

    /// ¿Esta face es la última y muestra el botón de "Comenzar"?
    /// Solo debe ser true en la última face del arreglo.
    /// Se gestiona automáticamente por OnboardingView; no necesitas
    /// cambiarlo manualmente salvo que reorganices las faces.
    var isLastPage: Bool = false
}
