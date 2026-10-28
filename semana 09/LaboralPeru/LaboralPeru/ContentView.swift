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
    @State private var horasSemanales = "23"
    @State private var mesPago = 10
    @State private var usaONP = true
    @State private var afp = "Integra"
    @State private var comisionSaldo = false
    @State private var resultadoInstructor: ResultadoInstructor?
    @State private var errorInstructor = ""
    @FocusState private var editando: Bool

    private let colorPrincipal = Color(red: 0.06, green: 0.38, blue: 0.39)

    // MARK: 2. Pantallas
    var body: some View {
        TabView {
            pantallaCTS
                .tabItem { Label("CTS", systemImage: "banknote") }
            pantallaGratificacion
                .tabItem { Label("Gratificación", systemImage: "gift") }
            pantallaInstructor
                .tabItem { Label("Instructores", systemImage: "person.crop.rectangle") }
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

    private var pantallaInstructor: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Pago mensual del instructor").font(.headline)
                    Text("Práctica: S/ 50 por hora · máximo 23 h/semana · 4 semanas")
                        .font(.subheadline).foregroundStyle(.secondary)
                    DisclosureGroup("Supuestos del ejemplo 2026") {
                        Text("Trabajador en planilla, régimen privado general, mismo sueldo de enero a diciembre, un empleador y dos gratificaciones completas. Sin otros ingresos, asignación familiar ni ausencias sin goce. EsSalud; las vacaciones pagadas mantienen el sueldo.")
                        Text("AFP: tasas de octubre de 2026. El mes seleccionado determina la quinta categoría, la gratificación y el piso de EsSalud.")
                    }.font(.footnote)
                }
                Section("1. Horas y mes") {
                    campo("Horas semanales", texto: $horasSemanales)
                    Picker("Mes de pago", selection: $mesPago) {
                        ForEach(1...12, id: \.self) { mes in
                            Text(Calculos.meses[mes - 1]).tag(mes)
                        }
                    }
                }
                Section("2. Sistema de pensiones") {
                    Picker("Sistema", selection: $usaONP) {
                        Text("ONP · 13%").tag(true)
                        Text("AFP").tag(false)
                    }.pickerStyle(.segmented)
                    if !usaONP {
                        Picker("AFP", selection: $afp) {
                            ForEach(Calculos.afps, id: \.self) { nombre in Text(nombre).tag(nombre) }
                        }
                        Toggle("Comisión sobre saldo", isOn: $comisionSaldo)
                        Text(comisionSaldo
                             ? "Aporte 10% + seguro 1.37%. La comisión anual se cobra del fondo; no se descuenta del sueldo."
                             : "Aporte 10% + seguro 1.37% + comisión sobre el sueldo, según AFP.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                }
                Section {
                    Button("Calcular pago", action: calcularInstructor)
                        .buttonStyle(.borderedProminent).controlSize(.large)
                    if !errorInstructor.isEmpty { Text(errorInstructor).foregroundStyle(.red) }
                }
                if let resultado = resultadoInstructor {
                    Section("3. Pago de \(Calculos.meses[mesPago - 1])") {
                        total("Total a recibir", monto: resultado.totalRecibir)
                        fila("Sueldo bruto", monto: resultado.bruto)
                        fila(usaONP ? "Aporte ONP" : "Aporte al fondo AFP", monto: resultado.aporte)
                        if !usaONP {
                            fila("Seguro AFP", monto: resultado.seguro)
                            fila("Comisión sobre sueldo", monto: resultado.comision)
                        }
                        fila("Descuento total pensión", monto: resultado.pension)
                        fila("Renta de quinta categoría", monto: resultado.quinta.total)
                        fila("Sueldo después de descuentos", monto: resultado.netoSueldo)
                        if resultado.gratificacion > 0 {
                            fila("Gratificación del mes", monto: resultado.gratificacion)
                            fila("Bonificación extraordinaria 9%", monto: resultado.bonificacion)
                        }
                        Text("Neto = bruto − pensión − quinta categoría. En julio y diciembre se suman la gratificación y su bonificación para obtener el total a recibir.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    Section("4. Aporte del empleador") {
                        fila("EsSalud", monto: resultado.essalud)
                        Text("9% a cargo del empleador; no se descuenta de tu sueldo. En un mes completo la base no puede ser inferior a la RMV.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    Section("5. Cómo se calculó quinta categoría") {
                        fila("Ingresos anuales para la retención ordinaria", monto: resultado.quinta.ingresosAnuales)
                        fila("Deducción: 7 UIT de S/ 5,500", monto: 7 * Calculos.uit)
                        fila("Renta neta anual gravable", monto: max(0, resultado.quinta.ingresosAnuales - 7 * Calculos.uit))
                        fila("Impuesto anual por tramos", monto: resultado.quinta.impuestoAnual)
                        fila("Retenciones previas que corresponde restar", monto: resultado.quinta.retencionesPrevias)
                        LabeledContent("Divisor del periodo", value: "\(resultado.quinta.divisor)")
                        fila("Retención ordinaria del mes", monto: resultado.quinta.ordinaria)
                        fila("Retención adicional por bonificación", monto: resultado.quinta.adicional)
                        Text("Tasas por tramos: 8%, 14%, 17%, 20% y 30%. El cálculo reconstruye las retenciones desde enero para este sueldo constante; no usa siempre impuesto anual / 12.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Instructores")
            .scrollDismissesKeyboard(.interactively)
            .toolbar { ToolbarItemGroup(placement: .keyboard) { Spacer(); Button("Listo") { editando = false } } }
            .onChange(of: [horasSemanales, "\(mesPago)", "\(usaONP)", afp, "\(comisionSaldo)"]) { _, _ in
                resultadoInstructor = nil; errorInstructor = ""
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

    private func calcularInstructor() {
        editando = false
        do {
            resultadoInstructor = try Calculos.calcularInstructor(
                horas: Calculos.leerNumero(horasSemanales), mes: mesPago,
                usaONP: usaONP, afp: afp, comisionSaldo: comisionSaldo)
            errorInstructor = ""
        } catch { resultadoInstructor = nil; errorInstructor = error.localizedDescription }
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
    static let uit = 5500.0 // UIT 2026, D. S. 301-2025-EF.
    static let meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
                        "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    static let afps = ["Habitat", "Integra", "Prima", "Profuturo"]

    // CTS: gratificacion recibe el monto completo; se divide entre seis una sola vez.
    // Los guard validan los importes, el tiempo y la jornada antes de calcular.
    // Ejemplo: sueldo 3000 y gratificacion 3000 dan una base de 3500.
    // Para seis meses y cero días: 3500 * 6 / 12 = S/ 1750.
    // Los días adicionales usan base / 360; se redondea la suma final.
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

    // Gratificación: meses representa meses calendario completos, entre cero y seis.
    // tieneEPS elige la bonificación: true usa 6.75%; false usa 9% por EsSalud.
    // Ejemplo sin EPS: 3000 * 6 / 6 = 3000; bono = 270; total = S/ 3270.
    // Este resultado es anterior a quinta categoría; esta función no calcula el IR.
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

    // Instructor: horas es la cantidad semanal; mes usa 1 para enero y 12 para diciembre.
    // Con 23 horas, el bruto del ejercicio es 23 * 50 * 4 = S/ 4600.
    // usaONP elige ONP o AFP. En AFP se separan aporte, seguro y comisión.
    // comisionSaldo evita descontar del sueldo una comisión que se cobra del fondo.
    // netoSueldo resta pensión e IR; totalRecibir añade gratificación y bono si corresponden.
    // El aporte EsSalud se devuelve por separado para mostrar el costo del empleador.
    static func calcularInstructor(horas: Double, mes: Int, usaONP: Bool,
                                   afp: String, comisionSaldo: Bool) throws -> ResultadoInstructor {
        guard horas.isFinite, horas > 0, horas <= 23, (1...12).contains(mes), afps.contains(afp) else {
            throw ErrorCalculo(mensaje: "Ingresa más de 0 y hasta 23 horas semanales y selecciona un mes y una AFP válidos.")
        }
        // Condiciones del enunciado, no una tarifa fijada por ley.
        let bruto = redondear(horas * 50 * 4)
        let tasasComision = ["Habitat": 0.0147, "Integra": 0.0155,
                             "Prima": 0.0160, "Profuturo": 0.0169]
        let aporte = redondear(bruto * (usaONP ? 0.13 : 0.10))
        // SBS octubre 2026. El bruto máximo del ejercicio es menor que el tope asegurable.
        let seguro = usaONP ? 0 : redondear(min(bruto, 12732.70) * 0.0137)
        let comision = usaONP || comisionSaldo ? 0 : redondear(bruto * (tasasComision[afp] ?? 0))
        let pension = redondear(aporte + seguro + comision)
        let quinta = calcularRetenciones(sueldo: bruto)[mes - 1]
        let netoSueldo = redondear(bruto - pension - quinta.total)
        let gratificacion = mes == 7 || mes == 12 ? bruto : 0
        let bonificacion = redondear(gratificacion * 0.09)
        // EsSalud lo paga el empleador y no se resta del neto.
        let rmv = mes >= 10 ? 1230.0 : 1130.0
        let essalud = redondear(max(bruto, rmv) * 0.09)
        return ResultadoInstructor(bruto: bruto, aporte: aporte, seguro: seguro,
            comision: comision, pension: pension, quinta: quinta, netoSueldo: netoSueldo,
            gratificacion: gratificacion, bonificacion: bonificacion, essalud: essalud,
            totalRecibir: redondear(netoSueldo + gratificacion + bonificacion))
    }

    // Impuesto progresivo: cada porcentaje se aplica solamente a su tramo.
    // Primero se restan siete UIT. Si no queda renta gravable, el impuesto es cero.
    // tamanos contiene la amplitud de cada tramo en UIT; restante guarda lo pendiente.
    // min toma solo la parte que cabe en el tramo, y el exceso final paga 30%.
    static func calcularImpuestoAnual(ingresos: Double) -> Double {
        var restante = max(0, ingresos - 7 * uit)
        var impuesto = 0.0
        let tamanos = [5.0, 15.0, 15.0, 10.0]
        let tasas = [0.08, 0.14, 0.17, 0.20]
        for i in 0..<tamanos.count {
            let tramo = min(restante, tamanos[i] * uit)
            impuesto += tramo * tasas[i]
            restante -= tramo
        }
        impuesto += restante * 0.30
        return redondear(impuesto)
    }

    // Art. 40 del Reglamento del IR. Ejemplo: mismo sueldo todo 2026 y dos gratificaciones.
    // Al reconstruir enero–diciembre, tenemos las retenciones anteriores sin pedirlas al usuario.
    // El factor 14 representa doce sueldos y dos gratificaciones completas.
    // corte indica cuántos meses anteriores se restan; divisor reparte el saldo del impuesto.
    // En julio y diciembre se agrega la retención por la bonificación extraordinaria.
    // Se devuelven doce resultados: la pantalla selecciona uno mediante el índice mes - 1.
    static func calcularRetenciones(sueldo: Double) -> [RetencionQuinta] {
        var retenciones: [RetencionQuinta] = []
        let bono = redondear(sueldo * 0.09)
        for mes in 1...12 {
            // La bonificación de julio ya pagada integra los ingresos acumulados desde agosto.
            let ingresosAnuales = sueldo * 14 + (mes > 7 ? bono : 0)
            let impuestoAnual = calcularImpuestoAnual(ingresos: ingresosAnuales)
            let corte: Int
            let divisor: Int
            switch mes {
            case 1...3: corte = 0; divisor = 12
            case 4: corte = 3; divisor = 9
            case 5...7: corte = 4; divisor = 8
            case 8: corte = 7; divisor = 5
            case 9...11: corte = 8; divisor = 4
            default: corte = 11; divisor = 1
            }
            let previas = redondear(retenciones.prefix(corte).reduce(0) { $0 + $1.total })
            let ordinaria = redondear(max(0, impuestoAnual - previas) / Double(divisor))
            // La bonificación extraordinaria del mes genera retención adicional (inciso e).
            let bonoActual = mes == 7 || mes == 12 ? bono : 0
            let adicional = redondear(calcularImpuestoAnual(ingresos: ingresosAnuales + bonoActual) - impuestoAnual)
            retenciones.append(RetencionQuinta(ingresosAnuales: ingresosAnuales,
                impuestoAnual: impuestoAnual, retencionesPrevias: previas, divisor: divisor,
                ordinaria: ordinaria, adicional: adicional, total: redondear(ordinaria + adicional)))
        }
        return retenciones
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
struct RetencionQuinta {
    let ingresosAnuales, impuestoAnual, retencionesPrevias: Double
    let divisor: Int
    let ordinaria, adicional, total: Double
}
struct ResultadoInstructor {
    let bruto, aporte, seguro, comision, pension: Double
    let quinta: RetencionQuinta
    let netoSueldo, gratificacion, bonificacion, essalud, totalRecibir: Double
}
struct ErrorCalculo: LocalizedError {
    let mensaje: String
    var errorDescription: String? { mensaje }
}
