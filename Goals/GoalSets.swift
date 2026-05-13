// ============================================================
// Goals/GoalSets.swift
// Ruta: DiaryApp/Goals/GoalSets.swift
//
// ╔══════════════════════════════════════════════════════════╗
// ║  ESTE ES EL ARCHIVO PRINCIPAL PARA EDITAR METAS.        ║
// ║                                                          ║
// ║  Aquí defines TODO el contenido de las metas:           ║
// ║    • Las 5 metas iniciales (Fase 1)                     ║
// ║    • Las 3 metas predefinidas de fases siguientes       ║
// ║    • El pool de metas de relleno (fillers)              ║
// ║                                                          ║
// ║  NO necesitas tocar GoalsViewModel, Goal, ni ninguna    ║
// ║  vista para cambiar títulos o descripciones de metas.   ║
// ╚══════════════════════════════════════════════════════════╝
//
// CÓMO EDITAR UNA META EXISTENTE:
//   1. Localiza el bloque GoalDefinition(...) correspondiente.
//   2. Cambia title: y/o description: entre comillas.
//   3. Listo. Los cambios afectan a usuarios nuevos.
//      Los usuarios existentes mantienen sus metas ya cargadas.
//
// CÓMO AGREGAR METAS DE RELLENO (fillerGoals):
//   El pool debe tener MÍNIMO 2 elementos (para los 2 slots).
//   Agregar más da variedad en fases futuras.
//
// CÓMO PREPARAR FASES FUTURAS (fase 3, 4...):
//   Agrega un caso en `additionalPhaseGoals` al final de este
//   archivo, siguiendo el patrón del switch en GoalsViewModel.
//
// ============================================================

import Foundation

// MARK: - Definición de meta (datos en crudo, sin UUID ni estado)

/// Estructura ligera que solo guarda el contenido de texto de una meta.
/// GoalsViewModel la convierte en un Goal completo cuando la necesita.
struct GoalDefinition {
    /// Título corto de la meta.
    /// RECOMENDACIÓN: máximo 40 caracteres para que quepa bien en la UI.
    var title: String

    /// Descripción de qué implica cumplir esta meta.
    /// RECOMENDACIÓN: 1-2 oraciones claras y motivadoras.
    var description: String
}

// MARK: - Catálogo central de metas

/// Todas las metas predefinidas de la aplicación, organizadas por fase.
/// GoalsViewModel consume estas definiciones para construir el estado activo.
struct GoalSets {

    // =========================================================
    // ╔══════════════════════════════════════════════════════╗
    // ║  FASE 1: LAS 5 METAS INICIALES ✏️ EDITAR AQUÍ ✏️   ║
    // ║                                                      ║
    // ║  Estas son las metas que VE CADA USUARIO al abrir   ║
    // ║  la app por primera vez. Son iguales para todos.    ║
    // ║                                                      ║
    // ║  REGLA: Este arreglo DEBE tener exactamente 5       ║
    // ║  elementos. GoalsViewModel valida esto con un        ║
    // ║  assert() en modo debug.                            ║
    // ╚══════════════════════════════════════════════════════╝
    static let initialGoals: [GoalDefinition] = [

        // ── META 1 ── ✏️ Reemplaza con tu meta real
        GoalDefinition(
            title: "Escribe tu primera entrada",
            description: "Abre el diario y redacta libremente sobre tu día."
                       + " No importa qué tan corta sea la entrada."
        ),

        // ── META 2 ── ✏️ Reemplaza con tu meta real
        GoalDefinition(
            title: "Registra 3 emociones distintas",
            description: "Completa el selector de emociones en una entrada"
                       + " del diario. Sé honesto/a con lo que sientes."
        ),

        // ── META 3 ── ✏️ Reemplaza con tu meta real
        GoalDefinition(
            title: "Agrega una foto a tu diario",
            description: "Adjunta al menos una fotografía en cualquier entrada."
                       + " Elige un momento que recuerdes con cariño."
        ),

        // ── META 4 ── ✏️ Reemplaza con tu meta real
        GoalDefinition(
            title: "Escribe 3 días seguidos",
            description: "Mantén una racha de 3 entradas en días consecutivos."
                       + " La constancia es la clave del autoconocimiento."
        ),

        // ── META 5 ── ✏️ Reemplaza con tu meta real
        GoalDefinition(
            title: "Explora tu galería de recuerdos",
            description: "Entra a la sección Galería y revisa las imágenes"
                       + " que has guardado en tus entradas del diario."
        )

        // =========================================================
        // ⚠️ NO AGREGUES MÁS DE 5 ELEMENTOS AQUÍ.
        // Si necesitas que la Fase 1 tenga más metas,
        // cambia la constante `goalsPerPhase` en GoalsViewModel.swift
        // y ajusta este arreglo al mismo número.
        // =========================================================
    ]

    // =========================================================
    // ╔══════════════════════════════════════════════════════╗
    // ║  FASE 2: 3 METAS PREDEFINIDAS ✏️ EDITAR AQUÍ ✏️   ║
    // ║                                                      ║
    // ║  Estas 3 metas aparecen cuando el usuario completa  ║
    // ║  todas las de Fase 1. Se combinan con 2 "slots"     ║
    // ║  que el usuario puede personalizar (o que el sistema ║
    // ║  rellena automáticamente con `fillerGoals`).         ║
    // ║                                                      ║
    // ║  REGLA: Este arreglo DEBE tener exactamente 3       ║
    // ║  elementos (predefined) + 2 slots = 5 activas.      ║
    // ╚══════════════════════════════════════════════════════╝
    static let phase2Goals: [GoalDefinition] = [

        // ── META A ── ✏️ Reemplaza con tu meta real
        GoalDefinition(
            title: "Escribe una semana completa",
            description: "Registra una entrada en el diario 7 días seguidos."
                       + " Celebra cada entrada como un logro."
        ),

        // ── META B ── ✏️ Reemplaza con tu meta real
        GoalDefinition(
            title: "Identifica tu emoción más frecuente",
            description: "Revisa tus entradas pasadas y observa qué emoción"
                       + " has seleccionado más veces esta semana."
        ),

        // ── META C ── ✏️ Reemplaza con tu meta real
        GoalDefinition(
            title: "Escribe sobre un reto que superaste",
            description: "Dedica una entrada a describir algo difícil que"
                       + " hayas logrado superar. Reconoce tu fortaleza."
        )

        // =========================================================
        // ⚠️ NO AGREGUES MÁS DE 3 ELEMENTOS AQUÍ.
        // Los 2 slots restantes los gestionan `fillerGoals` abajo.
        // =========================================================
    ]

    // =========================================================
    // ╔══════════════════════════════════════════════════════╗
    // ║  METAS DE RELLENO (FILLER) ✏️ EDITAR AQUÍ ✏️      ║
    // ║                                                      ║
    // ║  Pool de metas que el sistema usa para llenar los   ║
    // ║  slots vacíos que el usuario no personalizó.        ║
    // ║                                                      ║
    // ║  Si el usuario no agrega metas propias, el sistema  ║
    // ║  toma las 2 primeras de este arreglo.               ║
    // ║  Si el usuario agrega 1 propia, el sistema toma     ║
    // ║  solo la 1ª de este arreglo.                        ║
    // ║                                                      ║
    // ║  MÍNIMO: 2 elementos.                               ║
    // ║  RECOMENDADO: 4+ para tener variedad en fases       ║
    // ║  futuras (fase 3, 4...) donde puede haber más slots.║
    // ╚══════════════════════════════════════════════════════╝
    static let fillerGoals: [GoalDefinition] = [

        // ── RELLENO 1 ── ✏️ Reemplaza con tu meta real
        GoalDefinition(
            title: "Escribe sobre alguien importante",
            description: "Dedica una entrada a describir a una persona"
                       + " que sea importante en tu vida y por qué."
        ),

        // ── RELLENO 2 ── ✏️ Reemplaza con tu meta real
        GoalDefinition(
            title: "Describe tu lugar favorito",
            description: "Escribe sobre un lugar donde te sientas seguro/a"
                       + " y tranquilo/a. ¿Qué lo hace especial?"
        ),

        // ── RELLENO 3 ── ✏️ (opcional, da variedad)
        GoalDefinition(
            title: "Escribe sobre una meta futura",
            description: "Imagina algo que quisieras lograr en el próximo mes."
                       + " Descríbelo con detalle en tu diario."
        ),

        // ── RELLENO 4 ── ✏️ (opcional, da variedad)
        GoalDefinition(
            title: "Anota tres cosas buenas del día",
            description: "Al terminar el día, identifica y escribe tres cosas"
                       + " positivas que hayas vivido, grandes o pequeñas."
        )
    ]

    // =========================================================
    // ╔══════════════════════════════════════════════════════╗
    // ║  FASES FUTURAS (3, 4, 5...) ✏️ EXTENSIBILIDAD      ║
    // ║                                                      ║
    // ║  Para agregar una Fase 3 completa:                  ║
    // ║    1. Agrega un arreglo `phase3Goals` aquí.         ║
    // ║    2. Ve a GoalsViewModel.swift → func buildGoals() ║
    // ║       y agrega un case 3: con tus nuevas metas.     ║
    // ║    3. Ajusta el número de predefined vs slots según ║
    // ║       la lógica que necesites.                      ║
    // ║                                                      ║
    // ║  Ejemplo de declaración:                            ║
    // ║    static let phase3Goals: [GoalDefinition] = [...]║
    // ╚══════════════════════════════════════════════════════╝
    //
    // static let phase3Goals: [GoalDefinition] = [
    //     GoalDefinition(title: "Meta 3A", description: "..."),
    //     GoalDefinition(title: "Meta 3B", description: "..."),
    //     GoalDefinition(title: "Meta 3C", description: "..."),
    // ]
}
