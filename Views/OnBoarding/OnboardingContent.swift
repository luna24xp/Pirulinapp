// ============================================================
// Views/Onboarding/OnboardingContent.swift
// Ruta: DiaryApp/Views/Onboarding/OnboardingContent.swift
//
// ╔══════════════════════════════════════════════════════════╗
// ║  ESTE ES EL ARCHIVO QUE DEBES EDITAR PARA CAMBIAR       ║
// ║  TEXTOS, IMÁGENES Y ORDEN DE LAS FACES DEL ONBOARDING.  ║
// ║                                                          ║
// ║  No necesitas tocar ningún otro archivo para:            ║
// ║   • Cambiar títulos, subtítulos o descripciones          ║
// ║   • Cambiar colores de cada face                         ║
// ║   • Cambiar íconos SF Symbol o imágenes personalizadas   ║
// ║   • Agregar o quitar faces                               ║
// ╚══════════════════════════════════════════════════════════╝
//
// CÓMO AGREGAR UNA NUEVA FACE:
//   1. Copia uno de los bloques OnboardingPage(...) de abajo.
//   2. Pégalo en la posición que quieras dentro del arreglo `pages`.
//   3. Modifica título, texto, ícono y color.
//   4. Asegúrate de que solo la ÚLTIMA face tenga isLastPage: true.
//
// CÓMO QUITAR UNA FACE:
//   1. Elimina el bloque OnboardingPage(...) que ya no quieras.
//   2. El resto del sistema se ajusta automáticamente.
//
// CÓMO AGREGAR UNA IMAGEN PERSONALIZADA:
//   1. Arrastra tu imagen a Assets.xcassets en Xcode.
//   2. Nómbrala (ej. "onboarding_01_bienvenida").
//   3. En el OnboardingPage correspondiente, escribe:
//        imageName: "onboarding_01_bienvenida"
//      y deja symbolName con cualquier valor (no se mostrará).
//
// ============================================================

import SwiftUI

// MARK: - Proveedor de contenido del onboarding

/// Estructura estática que devuelve el arreglo de faces del onboarding.
/// No tiene estado; solo organiza el contenido de forma centralizada.
struct OnboardingContent {

    // =========================================================
    // MARK: - ✏️  ARREGLO DE FACES — EDITA AQUÍ ✏️
    //
    // Cada OnboardingPage(...) es una face del carrusel.
    // El ORDEN en el arreglo = el ORDEN en que se muestran.
    // La ÚLTIMA face del arreglo debe tener isLastPage: true.
    // =========================================================
    static var pages: [OnboardingPage] {

        // Marca automáticamente la última face como isLastPage
        var result = rawPages
        if !result.isEmpty {
            result[result.count - 1].isLastPage = true
        }
        return result
    }

    // FACES INDIVIDUALES

    private static var rawPages: [OnboardingPage] = [

        //  FACE 1 — BIENVENIDA
        
        OnboardingPage(
            imageName: "onboarding_01_bienvenida",
            symbolName: "",
            symbolColor: Color.purple,               // color del ícono

            // TEXTOS
            
            title: "¡Bienvenido/a a tu\nnueva forma de mejorar tu calidad de vida",
            subtitle: "Un lugar pensado para ti, Algo personal 🌟",
            body: "Este es tu nuevo diario, un espacio seguro donde "
                + "puedes expresarte con total libertad.\n\n"
                + "Aquí no hay respuestas correctas ni incorrectas: "
                + "solo tu historia, contada a tu manera."
                + "Y recuerda: ¡tú eres el propietario de tu propia vida!",

            
            accentColor: Color.purple,
            hasBulletPoints: false
        ),

        //  FACE 2 — QUÉ ES EL DIARIO
        OnboardingPage(
            // IMAGEN
            imageName: "onboarding_02_diario",
            symbolName: "",
            symbolColor: Color(red: 0.4, green: 0.6, blue: 1.0),

            // TEXTOS
            title: "Tu diario,\ntu historia",
            subtitle: "Escribe sobre tu día cada vez que quieras",
            body: "Cada día tendrás un espacio para contar tu día "
                + "todo lo que viviste, sentiste o pensaste.\n\n"
                + "No hay un mínimo de palabras. Puedes escribir una oración "
                + "o llenar páginas enteras, tú decides.",

            // ESTILO
            accentColor: Color(red: 0.4, green: 0.6, blue: 1.0),
            hasBulletPoints: true,
            bulletPoints: [
                // EDITAR: agrega o quita filas cambiando (emoji, texto)
                ("📝", "Redacta tu día con tus propias palabras"),  // 📝
                ("🔒", "Todo es privado y solo visible para ti"),    // 🔒
                ("🗓️", "Revisa entradas pasadas cuando quieras")     // 🗓️
            ]
        ),

        //  FACE 3 — EMOCIONES

        OnboardingPage(
            // IMAGEN
            imageName: "onboarding_03_emociones",
            symbolName: "",
            symbolColor: Color(red: 1.0, green: 0.35, blue: 0.55),

            // TEXTOS
            title: "¿Cómo te\nsentiste hoy?",
            subtitle: "Registra tus 3 emociones más importantes",
            body: "Cada entrada del diario incluye un selector de emociones "
                + "donde elegirás las 3 que más te representaron en el día.\n\n"
                + "Reconocer cómo te sientes es el primer paso para "
                + "entenderte mejor.",

            // ESTILO
            accentColor: Color(red: 1.0, green: 0.35, blue: 0.55),
            hasBulletPoints: true,
            bulletPoints: [
                // EDITAR: lista de emociones destacadas que verán en la app
                ("☺️", "Alegría, esperanza, gratitud..."),           // 😊
                ("😰", "Ansiedad, frustración, tristeza..."),        // 😰
                ("🤔", "\u{00A1}Y muchas más para elegir!")          // 🤔
            ]
        ),

       
        //  FACE 4 — GALERÍA DE FOTOS
        
        OnboardingPage(
            // IMAGEN
          
            imageName: "onboarding_04_galeria",
            symbolName: "",
            symbolColor: Color(red: 0.30, green: 0.80, blue: 0.40),

            // TEXTOS
            title: "Guarda los\nmomentos importantes",
            subtitle: "Hasta 2 fotos por entrada",
            body: "Puedes adjuntar hasta 2 fotografías a cada entrada "
                + "de tu diario. Son completamente opcionales.\n\n"
                + "Todas las fotos que agregues se guardan en la galeria del díario "
                + "personal dentro de la app, a la que puedes acceder "
                + "en cualquier momento.",

            // ESTILO
            accentColor: Color(red: 0.30, green: 0.80, blue: 0.40),
            hasBulletPoints: false
        ),

       
        //   FACE 5 — OBJETIVO Y REGLAS (ÚLTIMA FACE)
        // NOTA: Esta face se marca automáticamente como la
        // última por OnboardingContent.pages. No borres la
        // última posición sin reasignar isLastPage: true.

        OnboardingPage(
            // IMAGEN
            imageName: "onboarding_05_objetivo",
            symbolName: "",
            symbolColor: Color(red: 1.0, green: 0.70, blue: 0.10),

            // TEXTOS
            title: "¿Cuál es el\nobjetivo?",
            subtitle: "Tu bienestar, día a día 🌱",
            body: "Este diario es una herramienta para que te conozcas "
                + "mejor. Al escribir y registrar tus emociones cada día, "
                + "empezarás a descubrir patrones en tu vida.\n\n"
                + "Próximamente: metas personales y seguimiento de tu "
                + "bienestar emocional.",

            // ESTILO
            accentColor: Color(red: 1.0, green: 0.70, blue: 0.10),
            hasBulletPoints: true,
            bulletPoints: [
                // EDITAR: reglas o principios de la app
                ("✍️", "Escribe honestamente, sin juzgarte"), // ✍️
                ("📆", "Intenta escribir todos los días"),           // 📅
                ("🤫", "Tu diario es completamente privado"),        // 🤫
                ("💛", "Se amable contigo mismo/a!") // 💛
            ]
        ),
        
        

        // =========================================================
        // EXTENSIBILIDAD: Para agregar una nueva face, copia
        // uno de los bloques OnboardingPage(...) de arriba y
        // pégalo aquí, antes del paréntesis de cierre del arreglo.
        // Recuerda: la ÚLTIMA del arreglo recibe isLastPage: true
        // automáticamente. No pongas isLastPage: true manualmente.
        // =========================================================
    ]
}
