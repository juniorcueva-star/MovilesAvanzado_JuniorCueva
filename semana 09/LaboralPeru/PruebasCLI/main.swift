import Foundation

// Comprobaciones portables sin XCTest. Compilar junto con ContentView.swift en Windows.
// Las pruebas de Xcode adicionales están en LaboralPeruTests.swift.
var comprobaciones = 0
func comprobar(_ valor: Double, _ esperado: Double, _ nombre: String) {
    precondition(abs(valor - esperado) < 0.001, "\(nombre): se obtuvo \(valor); se esperaba \(esperado)")
    comprobaciones += 1
}

let cts = try Calculos.calcularCTS(sueldo: 3000, gratificacion: 3000, meses: 6, dias: 0, cumpleJornada: true)
comprobar(cts.total, 1750, "CTS semestre completo")
let ctsDias = try Calculos.calcularCTS(sueldo: 3000, gratificacion: 3000, meses: 3, dias: 15, cumpleJornada: true)
comprobar(ctsDias.total, 1020.83, "CTS con días")
let grati = try Calculos.calcularGratificacion(sueldo: 3000, meses: 6, tieneEPS: false)
comprobar(grati.total, 3270, "Gratificación EsSalud")
let eps = try Calculos.calcularGratificacion(sueldo: 3000, meses: 3, tieneEPS: true)
comprobar(eps.total, 1601.25, "Gratificación EPS proporcional")

let onp = try Calculos.calcularInstructor(horas: 23, mes: 10, usaONP: true, afp: "Integra", comisionSaldo: false)
comprobar(onp.totalRecibir, 3829.34, "Neto ONP octubre")
comprobar(onp.essalud, 414, "EsSalud empleador")
let afp = try Calculos.calcularInstructor(horas: 23, mes: 10, usaONP: false, afp: "Integra", comisionSaldo: false)
comprobar(afp.totalRecibir, 3833.02, "Neto AFP flujo octubre")
let saldo = try Calculos.calcularInstructor(horas: 23, mes: 10, usaONP: false, afp: "Integra", comisionSaldo: true)
comprobar(saldo.pension, 523.02, "AFP saldo sin comisión salarial")
let parcial = try Calculos.calcularInstructor(horas: 5, mes: 10, usaONP: true, afp: "Integra", comisionSaldo: false)
comprobar(parcial.essalud, 110.70, "Piso de EsSalud")
comprobar(parcial.totalRecibir, 870, "EsSalud no reduce neto")

let ingresos = [38500.0, 38501, 66000, 148500, 231000, 286000, 291500]
let impuestos = [0.0, 0.08, 2200, 13750, 27775, 38775, 40425]
for i in ingresos.indices {
    comprobar(Calculos.calcularImpuestoAnual(ingresos: ingresos[i]), impuestos[i], "Tramo IR \(i)")
}
let retenciones = Calculos.calcularRetenciones(sueldo: 4600)
comprobar(retenciones[0].total, 172.67, "Quinta enero")
comprobar(retenciones[6].total, 205.79, "Quinta julio")
comprobar(retenciones[9].total, 172.66, "Quinta octubre")
comprobar(retenciones[11].total, 205.79, "Quinta diciembre")
comprobar(retenciones.reduce(0) { $0 + $1.total }, 2138.24, "Conciliación anual")
for sueldo in [1000.0, 2700, 2720, 2750, 3000, 4600, 4700, 12000] {
    let pagos = Calculos.calcularRetenciones(sueldo: sueldo)
    let anual = Calculos.calcularImpuestoAnual(ingresos: sueldo * 14 + 2 * Calculos.redondear(sueldo * 0.09))
    comprobar(pagos.reduce(0) { $0 + $1.total }, anual, "Conciliación sueldo \(sueldo)")
}
comprobar(try Calculos.leerNumero("3000,50"), 3000.5, "Decimal con coma")
for texto in ["", "nan", "inf", "-1", "1e3", "1.000,50", "3,000", "2.222"] {
    do { _ = try Calculos.leerNumero(texto); preconditionFailure("Se aceptó \(texto)") }
    catch { comprobaciones += 1 }
}
for horas in [0.0, -1, 23.01, Double.infinity] {
    do {
        _ = try Calculos.calcularInstructor(horas: horas, mes: 10, usaONP: true, afp: "Integra", comisionSaldo: false)
        preconditionFailure("Se aceptaron horas fuera de rango")
    } catch { comprobaciones += 1 }
}
print("Correcto: \(comprobaciones) comprobaciones de cálculos y validaciones.")
