import SwiftUI

// MARK: - Modelo de datos

struct Pregunta {
    let numero: Int
    let titulo: String
    let texto: String
    let opciones: [Opcion]
    let esConclusion: Bool
}

struct Opcion {
    let valor: Int
    let texto: String
}

// MARK: - Datos del cuestionario

let preguntas: [Pregunta] = [
    Pregunta(
        numero: 1,
        titulo: "Relaciones y pertenencia",
        texto: "¿Cómo te sientes respecto a tu conexión con tus amigos y el grupo de personas con las que convives a diario?",
        opciones: [
            Opcion(valor: 5, texto: "Súper conectado: Tengo amigos de verdad y me divierto mucho con ellos."),
            Opcion(valor: 4, texto: "Bien: Me llevo bien con la mayoría y no suelo tener problemas."),
            Opcion(valor: 3, texto: "Neutral: A veces me siento parte del grupo, a veces no tanto."),
            Opcion(valor: 2, texto: "Algo solo: Siento que no encajo del todo o tengo discusiones frecuentes."),
            Opcion(valor: 1, texto: "Muy aislado: Siento que no tengo a quién acudir o me siento excluido.")
        ],
        esConclusion: false
    ),
    Pregunta(
        numero: 2,
        titulo: "Bienestar físico y energía",
        texto: "Al despertar por las mañanas y empezar tu rutina, ¿cómo describirías tu nivel de energía y salud física?",
        opciones: [
            Opcion(valor: 5, texto: "A tope: Me siento con mucha fuerza, descanso bien y mi cuerpo se siente genial."),
            Opcion(valor: 4, texto: "Con energía: La mayoría de los días me siento bien y rindo sin problemas."),
            Opcion(valor: 3, texto: "Pasable: Me canso un poco, pero logro terminar el día."),
            Opcion(valor: 2, texto: "Agotado: Casi siempre tengo sueño o me siento físicamente pesado/débil."),
            Opcion(valor: 1, texto: "Por los suelos: Me cuesta mucho hacer cualquier cosa y nunca descanso bien.")
        ],
        esConclusion: false
    ),
    Pregunta(
        numero: 3,
        titulo: "Entorno escolar y presión",
        texto: "¿Qué sensación te produce pensar en tus responsabilidades académicas y el ambiente que vives en la secundaria?",
        opciones: [
            Opcion(valor: 5, texto: "Motivado: Me gusta lo que aprendo y el ambiente escolar me resulta agradable."),
            Opcion(valor: 4, texto: "Tranquilo: Hay retos, pero siento que puedo con ellos sin estresarme demasiado."),
            Opcion(valor: 3, texto: "Indiferente: Es algo que 'tengo que hacer', no me emociona pero tampoco me quita el sueño."),
            Opcion(valor: 2, texto: "Agobiado: El estudio o el ambiente escolar me generan mucha ansiedad."),
            Opcion(valor: 1, texto: "Muy estresado: Siento una presión que me supera por completo.")
        ],
        esConclusion: false
    ),
    Pregunta(
        numero: 4,
        titulo: "Autonomía y tiempo libre",
        texto: "¿Cómo te hace sentir la cantidad de tiempo que tienes para dedicarle a tus hobbies o a no hacer 'nada'?",
        opciones: [
            Opcion(valor: 5, texto: "Muy satisfecho: Tengo el equilibrio perfecto entre mis deberes y lo que me apasiona."),
            Opcion(valor: 4, texto: "Satisfecho: Generalmente tengo tiempo para mis cosas después de cumplir con lo mío."),
            Opcion(valor: 3, texto: "Aceptable: Tengo algo de tiempo, aunque me gustaría que fuera más."),
            Opcion(valor: 2, texto: "Limitado: Casi no tengo tiempo para mí por tantas obligaciones."),
            Opcion(valor: 1, texto: "Atrapado: Siento que mi vida son solo deberes y no tengo espacio para disfrutar.")
        ],
        esConclusion: false
    ),
    Pregunta(
        numero: 5,
        titulo: "Autoconcepto y ánimo general",
        texto: "En general, cuando estás a solas y piensas en quién eres y cómo va tu vida, ¿qué sientes?",
        opciones: [
            Opcion(valor: 5, texto: "Muy feliz: Me gusta quién soy y estoy muy emocionado por el presente."),
            Opcion(valor: 4, texto: "Contento: Me siento cómodo conmigo mismo la mayor parte del tiempo."),
            Opcion(valor: 3, texto: "Estable: No me quejo, pero tampoco siento que esté en mi mejor momento."),
            Opcion(valor: 2, texto: "Desanimado: Me cuesta encontrar cosas que me hagan sentir bien conmigo mismo."),
            Opcion(valor: 1, texto: "Muy triste o frustrado: Me siento muy insatisfecho con mi situación actual.")
        ],
        esConclusion: false
    ),
    Pregunta(
        numero: 6,
        titulo: "¿Cómo te sientes ahora?",
        texto: "¿Cómo te sientes después de responder estas preguntas?",
        opciones: [
            Opcion(valor: 5, texto: "Muy bien, fue útil reflexionar sobre esto."),
            Opcion(valor: 4, texto: "Bien, fue interesante."),
            Opcion(valor: 3, texto: "Normal, ni bien ni mal."),
            Opcion(valor: 2, texto: "Un poco incómodo, me hizo pensar en cosas difíciles."),
            Opcion(valor: 1, texto: "Mal, no me gustó responder esto.")
        ],
        esConclusion: true
    )
]

// MARK: - Lógica de resultados

func calcularResultado(respuestas: [Int: Int]) -> (etiqueta: String, color: Color, descripcion: String) {
    let valoresPrincipales = (0..<5).compactMap { respuestas[$0] }
    guard valoresPrincipales.count == 5 else {
        return ("—", .gray, "Responde todas las preguntas para ver tu resultado.")
    }
    let promedio = Double(valoresPrincipales.reduce(0, +)) / 5.0

    switch promedio {
    case 4.2...5.0:
        return ("Muy buena", .green,
                "¡Genial! Tu calidad de vida es excelente. Sigue así y disfruta esta etapa.")
    case 3.4..<4.2:
        return ("Buena", .teal,
                "Tu vida va bien. Hay pequeñas áreas donde mejorar, pero en general estás bien.")
    case 2.6..<3.4:
        return ("Media", .orange,
                "Tienes aspectos positivos y otros que podrían mejorar. Vale la pena prestarles atención.")
    case 1.8..<2.6:
        return ("Mala", .red,
                "Parece que estás pasando por un momento difícil. Hablar con alguien de confianza puede ayudar.")
    default:
        return ("Muy mala", Color(red: 0.7, green: 0.0, blue: 0.0),
                "Estás en un momento muy complicado. Por favor, busca apoyo con un adulto de confianza.")
    }
}

// MARK: - Vista principal

struct ContentView: View {
    @State private var respuestas: [Int: Int] = [:]
    @State private var mostrarResultado = false

    var todasRespondidas: Bool {
        respuestas.count == preguntas.count
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                VStack(spacing: 6) {
                    Text("¿Cómo estoy?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Cuestionario de calidad de vida")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)

                ForEach(preguntas.indices, id: \.self) { idx in
                    TarjetaPregunta(
                        pregunta: preguntas[idx],
                        indice: idx,
                        seleccion: Binding(
                            get: { respuestas[idx] },
                            set: { respuestas[idx] = $0 }
                        )
                    )
                }

                Button(action: { mostrarResultado = true }) {
                    Text("Ver mi resultado")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(todasRespondidas ? Color.blue : Color.gray.opacity(0.4))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                .disabled(!todasRespondidas)
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $mostrarResultado) {
            VistaResultado(respuestas: respuestas)
        }
    }
}

// MARK: - Tarjeta de pregunta
struct TarjetaPregunta: View {
    let pregunta: Pregunta
    let indice: Int
    @Binding var seleccion: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(alignment: .top, spacing: 10) {
                Text("\(pregunta.numero)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 26, height: 26)
                    .background(pregunta.esConclusion ? Color.purple : Color.blue)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(pregunta.titulo)
                        .font(.headline)
                    if pregunta.esConclusion {
                        Text("Esta respuesta no afecta tu resultado final.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Text(pregunta.texto)
                .font(.subheadline)
                .foregroundColor(.secondary)

            VStack(spacing: 8) {
                ForEach(pregunta.opciones, id: \.valor) { opcion in
                    
                    // 👇 SOLUCIÓN: Calculamos la condición una sola vez aquí
                    let estaSeleccionada = (seleccion == opcion.valor)

                    Button(action: { seleccion = opcion.valor }) {
                        HStack(spacing: 12) {
                            // Usamos el booleano simple en lugar de la comparación compleja
                            Image(systemName: estaSeleccionada
                                  ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(estaSeleccionada ? .blue : .secondary)
                                .font(.title3)

                            Text(opcion.texto)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)

                            Spacer()
                        }
                        .padding(10)
                        .background(
                            estaSeleccionada
                                ? Color.blue.opacity(0.08)
                                : Color.gray.opacity(0.06)
                        )
                        .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
        .background(.background)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}
// MARK: - Vista de resultado

struct VistaResultado: View {
    let respuestas: [Int: Int]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        let resultado = calcularResultado(respuestas: respuestas)

        ScrollView {
            VStack(spacing: 28) {

                VStack(spacing: 12) {
                    Image(systemName: iconoPara(resultado.etiqueta))
                        .font(.system(size: 64))
                        .foregroundColor(resultado.color)

                    Text("Tu calidad de vida es")
                        .font(.title3)
                        .foregroundColor(.secondary)

                    Text(resultado.etiqueta)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(resultado.color)
                }
                .padding(.top, 40)

                Text(resultado.descripcion)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Tu resumen")
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(0..<5, id: \.self) { idx in
                        if let valor = respuestas[idx] {
                            HStack {
                                Text(preguntas[idx].titulo)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                ForEach(1...5, id: \.self) { i in
                                    Circle()
                                        .fill(i <= valor ? Color.blue : Color.gray.opacity(0.2))
                                        .frame(width: 10, height: 10)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                if let valorConclusion = respuestas[5] {
                    Divider()
                    VStack(spacing: 6) {
                        Text("¿Cómo te sentiste al responder?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(preguntas[5].opciones.first { $0.valor == valorConclusion }?.texto ?? "")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }

                Button(action: { dismiss() }) {
                    Text("Volver al cuestionario")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                .padding([.horizontal, .bottom])
            }
        }
    }

    func iconoPara(_ etiqueta: String) -> String {
        switch etiqueta {
        case "Muy buena": return "star.fill"
        case "Buena":     return "sun.max.fill"
        case "Media":     return "cloud.sun.fill"
        case "Mala":      return "cloud.rain.fill"
        default:          return "cloud.bolt.rain.fill"
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
