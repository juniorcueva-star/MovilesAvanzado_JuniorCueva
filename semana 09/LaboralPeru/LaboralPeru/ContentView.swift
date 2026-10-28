import Foundation

// SwiftUI funciona en Xcode. Esta condición permite probar las mismas fórmulas en Windows.
#if canImport(SwiftUI)
import SwiftUI

struct ContentView: View {
    // MARK: 1. Datos que escribe el usuario
    @State private var sueldoCTS = "3000"
    @State private var gratificacionRecibida = "3000"
    @State private var mesesCTS = 6
    @State private var diasCTS = 0
    @State private var cumpleJornada = true
    @State private var vacacionesAdquiridas = 30
    @State private var vacacionesGozadas = 0
    @State private var resultadoCTS: ResultadoCTS?
    @State private var errorCTS = ""

    @State private var sueldoGratificacion = "3000"
    @State private var mesesGratificacion = 6
    @State private var tieneEPS = false
    @State private var resultadoGratificacion: ResultadoGratificacion?
    @State private var errorGratificacion = ""
    @FocusState private var editando: Bool

    private let colorPrincipal = Color(red: 0.06, green: 0.38, blue: 0.39)

    // MARK: 2. Pantallas
    var body: some View {
        TabView {
            pantallaCTS
                .tabItem { Label("CTS", systemImage: "banknote") }
            pantallaGratificacion
                .tabItem { Label("Gratificación", systemImage: "gift") }
        }
        .tint(colorPrincipal)
    }

    private var pantallaCTS: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Tu ahorro por tiempo de servicio")
                        .font(.headline)
                    Text("Régimen privado general · remuneración fija")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                Section("1. Remuneración") {
                    campo("Remuneración mensual computable (S/)", texto: $sueldoCTS)
                    campo("Gratificación recibida en el semestre CTS (S/)", texto: $gratificacionRecibida)
                    Text("Ingresa la gratificación completa, sin la bonificación del 9% o 6.75%. Aquí se divide entre seis.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                Section("2. Tiempo computable") {
                    Stepper("Meses: \(mesesCTS)", value: $mesesCTS, in: 1...6)
                    Stepper("Días adicionales: \(diasCTS)", value: $diasCTS, in: 0...29)
                        .disabled(mesesCTS == 6)
                    Toggle("Cumple el promedio mínimo de 4 h/día", isOn: $cumpleJornada)
                    Text("Periodos: noviembre–abril o mayo–octubre. Cuenta las vacaciones pagadas. Ingresa el tiempo ya computable, descontando las ausencias que no correspondan.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                Section {
                    Button("Calcular CTS", action: calcularCTS)
                        .buttonStyle(.borderedProminent).controlSize(.large)
                    if !errorCTS.isEmpty { Text(errorCTS).foregroundStyle(.red) }
                }
                if let resultado = resultadoCTS {
                    Section("3. Resultado") {
                        total("CTS a depositar", monto: resultado.total)
                        fila("Un sexto de gratificación", monto: resultado.sexto)
                        fila("Base de cálculo", monto: resultado.base)
                        fila("Por meses trabajados", monto: resultado.porMeses)
                        fila("Por días adicionales", monto: resultado.porDias)
                        Text("CTS = base × (meses / 12 + días / 360)")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                }
                Section("Vacaciones pagadas: ejemplo de saldo") {
                    Stepper("Días ya adquiridos: \(vacacionesAdquiridas)", value: $vacacionesAdquiridas, in: 0...30)
                    Stepper("Días gozados: \(vacacionesGozadas)", value: $vacacionesGozadas, in: 0...vacacionesAdquiridas)
                    LabeledContent("Días pendientes", value: "\(vacacionesAdquiridas - vacacionesGozadas)")
                    Text("Tomar vacaciones pagadas no reduce la CTS. Los días adquiridos suponen cumplir el año y el récord vacacional. El saldo no es un pago extra.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("CTS Perú")
            .scrollDismissesKeyboard(.interactively)
            .toolbar { ToolbarItemGroup(placement: .keyboard) { Spacer(); Button("Listo") { editando = false } } }
            .onChange(of: mesesCTS) { _, nuevo in if nuevo == 6 { diasCTS = 0 } }
            .onChange(of: vacacionesAdquiridas) { _, nuevo in vacacionesGozadas = min(vacacionesGozadas, nuevo) }
            .onChange(of: [sueldoCTS, gratificacionRecibida, "\(mesesCTS)", "\(diasCTS)", "\(cumpleJornada)"]) { _, _ in
                resultadoCTS = nil; errorCTS = ""
            }
        }
    }

    private var pantallaGratificacion: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Fiestas Patrias o Navidad").font(.headline)
                    Text("Sueldo fijo, sin ausencias no computables. Las vacaciones pagadas sí cuentan.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                Section("1. Datos del semestre") {
                    campo("Remuneración computable (S/)", texto: $sueldoGratificacion)
                    Stepper("Meses calendario completos: \(mesesGratificacion)", value: $mesesGratificacion, in: 0...6)
                    Toggle("Cobertura EPS", isOn: $tieneEPS)
                    Text("Enero–junio para julio; julio–diciembre para Navidad. Bonificación: \(tieneEPS ? "6.75% por EPS" : "9% por EsSalud").")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                Section {
                    Button("Calcular gratificación", action: calcularGratificacion)
                        .buttonStyle(.borderedProminent).controlSize(.large)
                    if !errorGratificacion.isEmpty { Text(errorGratificacion).foregroundStyle(.red) }
                }
                if let resultado = resultadoGratificacion {
                    Section("2. Resultado") {
                        total("Importe antes de quinta categoría", monto: resultado.total)
                        fila("Gratificación legal", monto: resultado.gratificacion)
                        fila("Bonificación extraordinaria", monto: resultado.bonificacion)
                        Text("Gratificación = remuneración × meses / 6. No se descuenta AFP/ONP. La quinta categoría depende de los ingresos anuales.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Gratificación")
            .scrollDismissesKeyboard(.interactively)
            .toolbar { ToolbarItemGroup(placement: .keyboard) { Spacer(); Button("Listo") { editando = false } } }
            .onChange(of: [sueldoGratificacion, "\(mesesGratificacion)", "\(tieneEPS)"]) { _, _ in
                resultadoGratificacion = nil; errorGratificacion = ""
            }
        }
    }

    // MARK: 3. Acciones de los botones
    private func calcularCTS() {
        editando = false
        do {
            resultadoCTS = try Calculos.calcularCTS(
                sueldo: Calculos.leerNumero(sueldoCTS),
                gratificacion: Calculos.leerNumero(gratificacionRecibida),
                meses: mesesCTS, dias: diasCTS, cumpleJornada: cumpleJornada)
            errorCTS = ""
        } catch { resultadoCTS = nil; errorCTS = error.localizedDescription }
    }

    private func calcularGratificacion() {
        editando = false
        do {
            resultadoGratificacion = try Calculos.calcularGratificacion(
                sueldo: Calculos.leerNumero(sueldoGratificacion),
                meses: mesesGratificacion, tieneEPS: tieneEPS)
            errorGratificacion = ""
        } catch { resultadoGratificacion = nil; errorGratificacion = error.localizedDescription }
    }

    // MARK: 4. Diseño reutilizado en las tres pantallas
    private func campo(_ titulo: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo).font(.subheadline)
            TextField("0.00", text: texto)
                .keyboardType(.decimalPad).focused($editando)
                .font(.title3).foregroundStyle(colorPrincipal)
                .accessibilityLabel(titulo)
        }.padding(.vertical, 4)
    }

    private func fila(_ titulo: String, monto: Double) -> some View {
        LabeledContent(titulo, value: Calculos.soles(monto))
    }

    private func total(_ titulo: String, monto: Double) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo).font(.subheadline)
            Text(Calculos.soles(monto)).font(.largeTitle.bold()).minimumScaleFactor(0.6)
                .lineLimit(1).monospacedDigit()
        }
        .foregroundStyle(.white).padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colorPrincipal, in: RoundedRectangle(cornerRadius: 16))
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
    }
}

#Preview { ContentView() }
#endif

// MARK: 5. Fórmulas: están aquí para poder explicarlas junto con la interfaz
// Se agrupan en Calculos para probarlas sin depender de la pantalla.
enum Calculos {
    static func calcularCTS(sueldo: Double, gratificacion: Double, meses: Int,
                            dias: Int, cumpleJornada: Bool) throws -> ResultadoCTS {
        guard sueldo.isFinite, sueldo > 0, sueldo <= 1_000_000,
              gratificacion.isFinite, gratificacion >= 0, gratificacion <= 1_000_000 else {
            throw ErrorCalculo(mensaje: "Ingresa un sueldo mayor que cero y una gratificación no negativa, hasta S/ 1,000,000.")
        }
        guard (1...6).contains(meses), (0...29).contains(dias), meses < 6 || dias == 0 else {
            throw ErrorCalculo(mensaje: "Usa de 1 a 6 meses y hasta 29 días; seis meses no admiten días adicionales.")
        }
        guard cumpleJornada else {
            throw ErrorCalculo(mensaje: "En este régimen no corresponde CTS si no se cumple el promedio mínimo de cuatro horas diarias.")
        }
        let sexto = gratificacion / 6
        let base = sueldo + sexto
        let porMeses = base * Double(meses) / 12
        let porDias = base * Double(dias) / 360
        return ResultadoCTS(sexto: sexto, base: base, porMeses: porMeses,
                            porDias: porDias, total: redondear(porMeses + porDias))
    }

    static func calcularGratificacion(sueldo: Double, meses: Int, tieneEPS: Bool) throws -> ResultadoGratificacion {
        guard sueldo.isFinite, sueldo > 0, sueldo <= 1_000_000, (0...6).contains(meses) else {
            throw ErrorCalculo(mensaje: "Ingresa un sueldo válido hasta S/ 1,000,000 y entre 0 y 6 meses completos.")
        }
        let gratificacion = redondear(sueldo * Double(meses) / 6)
        let tasaBonificacion = tieneEPS ? 0.0675 : 0.09
        let bonificacion = redondear(gratificacion * tasaBonificacion)
        return ResultadoGratificacion(gratificacion: gratificacion, bonificacion: bonificacion,
                                      total: redondear(gratificacion + bonificacion))
    }

    static func leerNumero(_ texto: String) throws -> Double {
        let limpio = texto.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        // Acepta 3000,50 o 3000.50. No acepta separadores de miles ni notación científica.
        let partes = limpio.split(separator: ".", omittingEmptySubsequences: false)
        guard !limpio.isEmpty, limpio.allSatisfy({ "0123456789.".contains($0) }),
              partes.count <= 2, partes.count == 1 || partes[1].count <= 2,
              let valor = Double(limpio), valor.isFinite else {
            throw ErrorCalculo(mensaje: "Escribe un número con hasta dos decimales, sin separadores de miles. Ejemplo: 3000,50.")
        }
        return valor
    }

    static func redondear(_ valor: Double) -> Double { (valor * 100).rounded() / 100 }
    static func soles(_ valor: Double) -> String {
        valor.formatted(.currency(code: "PEN").locale(Locale(identifier: "es_PE")))
    }
}

// Estos tipos solamente guardan los valores que se muestran en pantalla.
struct ResultadoCTS {
    let sexto, base, porMeses, porDias, total: Double
}
struct ResultadoGratificacion {
    let gratificacion, bonificacion, total: Double
}
struct ErrorCalculo: LocalizedError {
    let mensaje: String
    var errorDescription: String? { mensaje }
}
