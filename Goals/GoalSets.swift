// ============================================================
// Goals/GoalSets.swift
// Base de datos de metas clasificadas por grupo emocional.
// ============================================================

import Foundation

struct GoalDefinition {
    var title: String
    var description: String
}

struct GoalSets {
    /// Diccionario central con las 120 metas divididas por grupos.
    static let goalsByGroup: [EmotionGroup: [GoalDefinition]] = [
        
        .alerta: [ // 5. Alerta y Desconexión
            GoalDefinition(title: "Inmersión térmica", description: "Lavarse la cara con agua muy fría durante 10 segundos al sentir un pico de ansiedad."),
            GoalDefinition(title: "Respiración prolongada", description: "Hacer 2 min de respiración donde la exhalación dure el doble que la inhalación."),
            GoalDefinition(title: "Anclaje de 1 minuto", description: "Mirar alrededor y nombrar mentalmente 3 objetos y sus texturas exactas."),
            GoalDefinition(title: "Micro-movimiento", description: "Cambiar de la cama a una silla o al sillón al menos una vez durante el día."),
            GoalDefinition(title: "Aislamiento controlado", description: "Apagar las notificaciones del celular durante 30 minutos seguidos en el día."),
            GoalDefinition(title: "Contacto mínimo", description: "Enviar un solo emoji o mensaje corto a alguien de confianza sin obligación de charlar."),
            GoalDefinition(title: "Higiene básica reducida", description: "Cepillarse los dientes al menos una vez al día o usar enjuague bucal."),
            GoalDefinition(title: "Estímulo auditivo pasivo", description: "Escuchar una sola canción favorita con los ojos cerrados, sin hacer nada más."),
            GoalDefinition(title: "Cambio de entorno", description: "Abrir una ventana y mirar hacia afuera durante 2 minutos seguidos."),
            GoalDefinition(title: "Nutrición sin esfuerzo", description: "Consumir un alimento que no requiera preparación para evitar caídas de glucosa."),
            GoalDefinition(title: "Reducción de estímulos", description: "Permanecer 10 min en una habitación con luz tenue y sin pantallas antes de dormir."),
            GoalDefinition(title: "Postura de liberación", description: "Estirar los brazos hacia el techo durante 15 segundos al levantarse."),
            GoalDefinition(title: "Aceptación radical", description: "Escribir en un papel una palabra que describa el malestar actual y dejarlo sin juzgar."),
            GoalDefinition(title: "Ducha de baja demanda", description: "Tomar una ducha tibia de 3 minutos, sin obligación de rutina de aseo compleja."),
            GoalDefinition(title: "Micro-orden", description: "Limpiar o despejar una sola superficie pequeña."),
            GoalDefinition(title: "Ropa limpia", description: "Cambiarse la playera o pijama por una prenda limpia, aunque no salgas de casa."),
            GoalDefinition(title: "Evitación de disparadores", description: "Pasar 24 horas completas sin leer o ver noticias de actualidad."),
            GoalDefinition(title: "Luz natural pasiva", description: "Sentarse cerca de donde entre luz solar durante 5 minutos por la mañana."),
            GoalDefinition(title: "Descanso de decisiones", description: "Delegar o posponer una decisión no urgente para la siguiente semana."),
            GoalDefinition(title: "Validación del estado", description: "Repetir: 'Está bien no sentirme bien hoy, mi cuerpo intenta protegerse'.")
        ],
        
        .repliegue: [ // 4. Repliegue y Dolor Social
            GoalDefinition(title: "Caminata corta", description: "Salir a caminar al aire libre durante exactamente 10 minutos seguidos."),
            GoalDefinition(title: "Exposición solar", description: "Mantener cortinas abiertas durante al menos 2 horas en el día."),
            GoalDefinition(title: "Registro de eficacia", description: "Escribir una cosa que hayas logrado terminar hoy, por pequeña que sea."),
            GoalDefinition(title: "Puente social", description: "Responder a un mensaje pendiente que hayas estado postergando."),
            GoalDefinition(title: "Presencia compartida", description: "Sentarse en un espacio común durante 15 minutos, sin necesidad de hablar."),
            GoalDefinition(title: "Meme-terapia", description: "Enviar un meme o un video corto divertido a un amigo o familiar."),
            GoalDefinition(title: "Eliminación de residuos", description: "Tirar a la basura 3 objetos o papeles inservibles acumulados."),
            GoalDefinition(title: "Compasión táctil", description: "Envolverse en una manta cómoda para inducir confort físico."),
            GoalDefinition(title: "Distracción nostálgica", description: "Ver un episodio de una serie o película de la infancia que te genere seguridad."),
            GoalDefinition(title: "Estiramiento suave", description: "Hacer 5 minutos de movimientos lentos para el cuello, hombros y espalda."),
            GoalDefinition(title: "Llenado de mente", description: "Leer 3 páginas de un libro de ficción o un artículo de interés general."),
            GoalDefinition(title: "Filtro digital", description: "Mutear a 3 cuentas en redes que te generen comparación o inferioridad."),
            GoalDefinition(title: "Micro-limpieza", description: "Lavar tres platos o cubiertos que estén en el fregadero."),
            GoalDefinition(title: "Música reguladora", description: "Escuchar ritmos alegres o intermedios por 10 min mientras te mueves."),
            GoalDefinition(title: "Agradecimiento breve", description: "Decir 'gracias' conscientemente a alguien que preste un servicio cotidiano."),
            GoalDefinition(title: "Cuidado de un ser vivo", description: "Regar una planta o pasar 5 minutos acariciando a una mascota."),
            GoalDefinition(title: "Límite saludable", description: "Decir 'no' a un compromiso social opcional que agotará tu batería."),
            GoalDefinition(title: "Descarga emocional", description: "Escribir todo lo que te genera tristeza por 2 minutos y luego romper el papel."),
            GoalDefinition(title: "Comida reconfortante", description: "Preparar un platillo que te guste mucho y comerlo prestando atención a los sabores."),
            GoalDefinition(title: "Cama hecha", description: "Estirar las sábanas y acomodar la almohada inmediatamente después de levantarse.")
        ],
        
        .defensa: [ // 3. Defensa y Reactividad
            GoalDefinition(title: "Pausa de 3 respiraciones", description: "Tomar 3 respiraciones lentas antes de responder a algo que te haya molestado."),
            GoalDefinition(title: "Descarga física intensa", description: "Realizar 10-15 min de ejercicio de alta intensidad para quemar cortisol."),
            GoalDefinition(title: "Carta de descarga", description: "Escribir tu ira sin filtros hacia alguien y borrarlo o destruirlo inmediatamente."),
            GoalDefinition(title: "Tiempo fuera autoimpuesto", description: "Pedir 10 minutos para pensar antes de seguir una discusión difícil."),
            GoalDefinition(title: "Liberación por presión", description: "Apretar una pelota antiestrés o almohada con fuerza por 30 seg."),
            GoalDefinition(title: "Identificación corporal", description: "Notar dónde se siente el enojo y concentrar el aire en relajar esa zona."),
            GoalDefinition(title: "Ayuno de opinión", description: "Pasar un día sin comentar, criticar o discutir en redes o foros."),
            GoalDefinition(title: "Silencio absoluto", description: "Dedicar 10 min del día a estar en completo silencio, sin pantallas."),
            GoalDefinition(title: "Bitácora de detonantes", description: "Anotar qué situación exacta disparó tu enojo durante el día."),
            GoalDefinition(title: "Reestructuración", description: "Cambiar 'Todo lo hacen mal' por 'Esto es frustrante, pero puedo manejarlo'."),
            GoalDefinition(title: "Control de entorno", description: "Organizar un espacio caótico para recuperar la sensación de orden."),
            GoalDefinition(title: "Moderación de estimulantes", description: "Reducir café o energéticas a máximo una taza al día esta semana."),
            GoalDefinition(title: "Redirección cognitiva", description: "Resolver un juego de lógica o Sudoku por 10 min para salir del bucle."),
            GoalDefinition(title: "Audio relajante", description: "Poner ruido blanco o lluvia de fondo mientras realizas tareas."),
            GoalDefinition(title: "Caminata de descompresión", description: "Caminar a paso veloz por 15 min sin música, observando el entorno."),
            GoalDefinition(title: "Comunicación asertiva", description: "Expresar inconformidad diciendo: 'Me siento X cuando pasa Y', sin insultar."),
            GoalDefinition(title: "Espacio verde", description: "Pasar 15 min sentado en un parque para reducir el estrés biológico."),
            GoalDefinition(title: "Planificación con margen", description: "Dejar 15 min libres entre actividades para evitar frustración por retraso."),
            GoalDefinition(title: "Desahogo verbal", description: "Hablar con un amigo explicando que solo necesitas ser escuchado por 5 min."),
            GoalDefinition(title: "Higiene del sueño", description: "Acostarse a la misma hora 4 días seguidos para prevenir irritabilidad.")
        ],
        
        .exploracion: [ // 2. Exploración y Logro
            GoalDefinition(title: "Micro-aprendizaje", description: "Dedicar 15 min a aprender un idioma o habilidad nueva."),
            GoalDefinition(title: "Lectura de desarrollo", description: "Leer un capítulo de un libro de no ficción o artículo científico."),
            GoalDefinition(title: "Planificación de metas", description: "Escribir un objetivo a 3 meses y desglosarlo en 5 acciones semanales."),
            GoalDefinition(title: "Ruta alternativa", description: "Cambiar tu ruta habitual para activar la plasticidad cerebral por novedad."),
            GoalDefinition(title: "Victoria de agenda", description: "Completar una tarea que llevabas postergando más de 2 semanas."),
            GoalDefinition(title: "Archivo de éxitos", description: "Escribir tus 3 mayores logros laborales, académicos o personales del año."),
            GoalDefinition(title: "Pregunta profunda", description: "Hacer una pregunta abierta a un mentor sobre su experiencia."),
            GoalDefinition(title: "Bloque de enfoque", description: "Trabajar 45 min continuos en un proyecto personal con el celular lejos."),
            GoalDefinition(title: "Exploración de contenido", description: "Ver un documental sobre un tema del cual no conozcas nada."),
            GoalDefinition(title: "Optimización", description: "Limpiar y organizar archivos de la PC o apps del celular para mejorar tu flujo."),
            GoalDefinition(title: "Prueba gastronómica", description: "Cocinar una receta nueva o probar un platillo de una cultura diferente."),
            GoalDefinition(title: "Espacio de creación", description: "Dedicar 20 min a un pasatiempo manual o creativo."),
            GoalDefinition(title: "Tablero de dirección", description: "Listar 5 experiencias o proyectos que te entusiasmaría realizar."),
            GoalDefinition(title: "Feedback proactivo", description: "Pedir a un colega o profesor una crítica constructiva sobre un trabajo."),
            GoalDefinition(title: "Aceptación de elogios", description: "Responder solo con 'Gracias, me costó esfuerzo' ante un cumplido."),
            GoalDefinition(title: "Consumo inspirador", description: "Escuchar un podcast sobre historias de superación o ciencia del éxito."),
            GoalDefinition(title: "Revisión de fin de semana", description: "Evaluar tu avance el viernes y otorgarte una pequeña recompensa."),
            GoalDefinition(title: "Diseño de espacio", description: "Modificar tu escritorio para optimizar tu comodidad y concentración."),
            GoalDefinition(title: "Discusión de ideas", description: "Compartir un concepto interesante que hayas descubierto con un amigo."),
            GoalDefinition(title: "Visualización", description: "Pasar 5 min imaginando los pasos lógicos para resolver un problema actual.")
        ],
        
        .bienestar: [ // 1. Bienestar y Conexión
            GoalDefinition(title: "Diario de gratitud", description: "Escribir en la mañana 3 cosas específicas por las que te sientes agradecido."),
            GoalDefinition(title: "Mensaje de apreciación", description: "Enviar un mensaje a un ser querido explicándole por qué valoras su presencia."),
            GoalDefinition(title: "Conversación plena", description: "Tener una charla de 30 min sin revisar el teléfono ni una sola vez."),
            GoalDefinition(title: "Atención plena", description: "Realizar una meditación o respiración consciente durante 10 min."),
            GoalDefinition(title: "Saboreo consciente", description: "Comer sin distracciones, enfocándote en texturas, aromas y sabores."),
            GoalDefinition(title: "Inmersión en la naturaleza", description: "Pasar 1 hora contemplativa en un bosque, parque grande o playa."),
            GoalDefinition(title: "Altruismo silencioso", description: "Ayudar a alguien en una tarea cotidiana de manera desinteresada."),
            GoalDefinition(title: "Detalle inesperado", description: "Dejar una nota amable o tener un gesto de cortesía con alguien cercano."),
            GoalDefinition(title: "Autocuidado radical", description: "Dedicar una tarde entera a actividades que te relajen profundamente."),
            GoalDefinition(title: "Reunión comunitaria", description: "Organizar o asistir a una comida o café con amigos para fortalecer vínculos."),
            GoalDefinition(title: "Carta al pasado", description: "Escribir una nota de agradecimiento a tu versión del pasado por haber resistido."),
            GoalDefinition(title: "Bitácora de alegrías", description: "Registrar al final del día al menos un momento que te hizo sonreír."),
            GoalDefinition(title: "Abrazo de oxitocina", description: "Dar un abrazo genuino de 20 segundos a un ser querido o acariciar a tu mascota."),
            GoalDefinition(title: "Recordatorio de confianza", description: "Declarar explícitamente tu confianza hacia el criterio de alguien."),
            GoalDefinition(title: "Revisión de memoria", description: "Mirar álbumes de fotos de momentos felices para reactivar el bienestar."),
            GoalDefinition(title: "Sesión corporal suave", description: "Dedicar 20 min a realizar estiramientos orientados a la relajación muscular."),
            GoalDefinition(title: "Elogio de carácter", description: "Hacer un cumplido enfocado en la ética, paciencia o inteligencia de alguien."),
            GoalDefinition(title: "Desconexión nocturna", description: "Apagar todas las pantallas 2 horas antes de dormir durante una noche."),
            GoalDefinition(title: "Alineación de valores", description: "Confirmar que al menos 3 actividades semanales estén alineadas a tus valores."),
            GoalDefinition(title: "Celebración compartida", description: "Invitar a alguien a celebrar una buena noticia o alegrarte por el logro de otro.")
        ],
        
        .universal: [ // 0. Universales
            GoalDefinition(title: "Hidratación base", description: "Beber entre 1.5 y 2 litros de agua a lo largo del día."),
            GoalDefinition(title: "Protección del sueño", description: "Dormir un bloque continuo de entre 7 y 8 horas por noche."),
            GoalDefinition(title: "Sincronización circadiana", description: "Exponerse a luz solar directa durante 10 min en la primera hora tras despertar."),
            GoalDefinition(title: "Pausa de transición", description: "Tomar 3 respiraciones profundas al cambiar de una actividad a otra."),
            GoalDefinition(title: "Movimiento mínimo", description: "Mantener el cuerpo en movimiento físico ligero por al menos 10 min al día."),
            GoalDefinition(title: "Anclaje de rutina", description: "Despertar e ir a dormir en horarios similares (variación máxima de 1 hora)."),
            GoalDefinition(title: "Nutrición mínima", description: "Asegurar al menos una comida completa al día con proteína y fibra limpia."),
            GoalDefinition(title: "Reinicio somático", description: "Lavarse cara y manos con agua fresca al mediodía para activar el nervio vago."),
            GoalDefinition(title: "Regla 20-20-20", description: "Desviar la mirada de pantallas cada 20 min hacia algo a 6 metros por 20 seg."),
            GoalDefinition(title: "Escaneo de tensión", description: "Revisar rigidez en cuello o mandíbula y relajar la zona conscientemente."),
            GoalDefinition(title: "Vaciado mental", description: "Anotar los pendientes en una libreta antes de dormir para vaciar la mente."),
            GoalDefinition(title: "Mañana sin dopamina", description: "Evitar redes sociales o correos en los primeros 15 min al despertar."),
            GoalDefinition(title: "Higiene de descanso", description: "Mantener donde duermes lo más ordenado, oscuro y fresco posible."),
            GoalDefinition(title: "Defensa de límites", description: "Decir 'no' a peticiones que interfieran con tus tiempos de comida o sueño."),
            GoalDefinition(title: "Estabilidad de glucosa", description: "Evitar pasar más de 6 horas despierto sin ingerir ningún alimento."),
            GoalDefinition(title: "Descompresión postural", description: "Estirar el cuello y rotar hombros hacia atrás 1 min tras estar sentado."),
            GoalDefinition(title: "Oxigenación diaria", description: "Pasar mínimo 5 min al aire libre todos los días, sin importar el clima."),
            GoalDefinition(title: "Autocompasión", description: "Reemplazar insultos ante un error por: 'Cometí un error, soy humano y lo corregiré'."),
            GoalDefinition(title: "Moderación inflamatoria", description: "Disminuir consumo de ultraprocesados ricos en azúcar si hay inestabilidad."),
            GoalDefinition(title: "Conciencia de transitoriedad", description: "Recordar: 'las emociones son estados transitorios, no rasgos permanentes'.")
        ]
    ]
}

