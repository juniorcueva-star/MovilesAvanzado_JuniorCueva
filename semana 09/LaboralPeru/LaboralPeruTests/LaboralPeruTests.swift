import XCTest
#if canImport(LaboralPeru)
@testable import LaboralPeru
#endif

final class LaboralPeruTests: XCTestCase {
    func testCTSSemestreCompleto() throws {
        let resultado = try Calculos.calcularCTS(sueldo: 3000, gratificacion: 3000,
                                                meses: 6, dias: 0, cumpleJornada: true)
        XCTAssertEqual(resultado.total, 1750, accuracy: 0.001)
    }

    func testGratificacionProporcionalEPS() throws {
        let resultado = try Calculos.calcularGratificacion(sueldo: 3000, meses: 3, tieneEPS: true)
        XCTAssertEqual(resultado.gratificacion, 1500, accuracy: 0.001)
        XCTAssertEqual(resultado.bonificacion, 101.25, accuracy: 0.001)
    }

    func testCTSDiasYValidaciones() throws {
        let resultado = try Calculos.calcularCTS(sueldo: 3000, gratificacion: 3000,
                                                meses: 3, dias: 15, cumpleJornada: true)
        XCTAssertEqual(resultado.total, 1020.83, accuracy: 0.001)
        XCTAssertThrowsError(try Calculos.calcularCTS(sueldo: 3000, gratificacion: 3000,
                                                    meses: 6, dias: 1, cumpleJornada: true))
        XCTAssertThrowsError(try Calculos.calcularCTS(sueldo: 3000, gratificacion: 3000,
                                                    meses: 6, dias: 0, cumpleJornada: false))
        XCTAssertThrowsError(try Calculos.calcularCTS(sueldo: .nan, gratificacion: 0,
                                                    meses: 6, dias: 0, cumpleJornada: true))
        let sinGratificacion = try Calculos.calcularCTS(sueldo: 3000, gratificacion: 0,
                                                       meses: 6, dias: 0, cumpleJornada: true)
        XCTAssertEqual(sinGratificacion.total, 1500, accuracy: 0.001)
    }

    func testGratificacionCompletaYCeroMeses() throws {
        let completa = try Calculos.calcularGratificacion(sueldo: 3000, meses: 6, tieneEPS: false)
        XCTAssertEqual(completa.total, 3270, accuracy: 0.001)
        let sinMesCompleto = try Calculos.calcularGratificacion(sueldo: 3000, meses: 0, tieneEPS: false)
        XCTAssertEqual(sinMesCompleto.total, 0)
        XCTAssertThrowsError(try Calculos.calcularGratificacion(sueldo: 0, meses: 6, tieneEPS: false))
        XCTAssertThrowsError(try Calculos.calcularGratificacion(sueldo: 3000, meses: 7, tieneEPS: false))
    }

    func testONPOctubreYGratificacionJulio() throws {
        let octubre = try Calculos.calcularInstructor(horas: 23, mes: 10, usaONP: true,
                                                    afp: "Integra", comisionSaldo: false)
        XCTAssertEqual(octubre.bruto, 4600)
        XCTAssertEqual(octubre.pension, 598)
        XCTAssertEqual(octubre.quinta.total, 172.66, accuracy: 0.001)
        XCTAssertEqual(octubre.totalRecibir, 3829.34, accuracy: 0.001)
        XCTAssertEqual(octubre.essalud, 414)
        let julio = try Calculos.calcularInstructor(horas: 23, mes: 7, usaONP: true,
                                                  afp: "Integra", comisionSaldo: false)
        XCTAssertEqual(julio.gratificacion, 4600)
        XCTAssertEqual(julio.bonificacion, 414)
        XCTAssertEqual(julio.pension, 598) // La gratificación no aumenta el aporte.
        XCTAssertEqual(julio.totalRecibir, 8810.21, accuracy: 0.001)
    }

    func testAFPFlujoYSaldo() throws {
        let flujo = try Calculos.calcularInstructor(horas: 23, mes: 10, usaONP: false,
                                                  afp: "Integra", comisionSaldo: false)
        XCTAssertEqual(flujo.aporte, 460)
        XCTAssertEqual(flujo.seguro, 63.02, accuracy: 0.001)
        XCTAssertEqual(flujo.comision, 71.30, accuracy: 0.001)
        XCTAssertEqual(flujo.totalRecibir, 3833.02, accuracy: 0.001)
        let saldo = try Calculos.calcularInstructor(horas: 23, mes: 10, usaONP: false,
                                                  afp: "Integra", comisionSaldo: true)
        XCTAssertEqual(saldo.comision, 0)
        XCTAssertEqual(saldo.pension, 523.02, accuracy: 0.001)
        let tasas = [0.0147, 0.0155, 0.016, 0.0169]
        for (i, nombre) in Calculos.afps.enumerated() {
            let resultado = try Calculos.calcularInstructor(horas: 23, mes: 10, usaONP: false,
                                                           afp: nombre, comisionSaldo: false)
            XCTAssertEqual(resultado.comision, Calculos.redondear(4600 * tasas[i]), accuracy: 0.001)
        }
    }

    func testLimitesHorasYMinimoEsSalud() throws {
        for horas in [0.0, -1, 23.01, Double.infinity] {
            XCTAssertThrowsError(try Calculos.calcularInstructor(horas: horas, mes: 10, usaONP: true,
                                                               afp: "Integra", comisionSaldo: false))
        }
        let parcial = try Calculos.calcularInstructor(horas: 5, mes: 10, usaONP: true,
                                                    afp: "Integra", comisionSaldo: false)
        XCTAssertEqual(parcial.bruto, 1000)
        XCTAssertEqual(parcial.quinta.total, 0)
        XCTAssertEqual(parcial.totalRecibir, 870) // EsSalud no se resta del neto.
        XCTAssertEqual(parcial.essalud, 110.70, accuracy: 0.001)
    }

    func testTramosImpuestoAnual() {
        XCTAssertEqual(Calculos.calcularImpuestoAnual(ingresos: 38500), 0)
        XCTAssertEqual(Calculos.calcularImpuestoAnual(ingresos: 38501), 0.08, accuracy: 0.001)
        // Límites acumulados: 7 UIT deducibles + 5, 20, 35 y 45 UIT gravadas.
        XCTAssertEqual(Calculos.calcularImpuestoAnual(ingresos: 66000), 2200)
        XCTAssertEqual(Calculos.calcularImpuestoAnual(ingresos: 148500), 13750)
        XCTAssertEqual(Calculos.calcularImpuestoAnual(ingresos: 231000), 27775)
        XCTAssertEqual(Calculos.calcularImpuestoAnual(ingresos: 286000), 38775)
        XCTAssertEqual(Calculos.calcularImpuestoAnual(ingresos: 291500), 40425)
    }

    func testRetencionesYConciliacionAnual() {
        let retenciones = Calculos.calcularRetenciones(sueldo: 4600)
        XCTAssertEqual(retenciones.map(\.divisor), [12, 12, 12, 9, 8, 8, 8, 5, 4, 4, 4, 1])
        XCTAssertEqual(retenciones[0].total, 172.67, accuracy: 0.001)
        XCTAssertEqual(retenciones[6].adicional, 33.12, accuracy: 0.001)
        XCTAssertEqual(retenciones[11].total, 205.79, accuracy: 0.001)
        XCTAssertEqual(retenciones.reduce(0) { $0 + $1.total }, 2138.24, accuracy: 0.001)
        // Sueldos a ambos lados de la exoneración y del primer cambio de tramo.
        for sueldo in [1000.0, 2700, 2720, 2750, 3000, 4600, 4700, 12000] {
            let pagos = Calculos.calcularRetenciones(sueldo: sueldo)
            let anual = Calculos.calcularImpuestoAnual(ingresos: sueldo * 14 + 2 * Calculos.redondear(sueldo * 0.09))
            XCTAssertEqual(pagos.reduce(0) { $0 + $1.total }, anual, accuracy: 0.001)
            XCTAssertTrue(pagos.allSatisfy { $0.total >= 0 })
        }
    }

    func testEntradaDecimal() throws {
        XCTAssertEqual(try Calculos.leerNumero("3000,50"), 3000.50)
        XCTAssertEqual(try Calculos.leerNumero(" 23.00 "), 23)
        for texto in ["", "nan", "inf", "-1", "1e3", "1.000,50", "3,000", "2.222"] {
            XCTAssertThrowsError(try Calculos.leerNumero(texto))
        }
    }
}
