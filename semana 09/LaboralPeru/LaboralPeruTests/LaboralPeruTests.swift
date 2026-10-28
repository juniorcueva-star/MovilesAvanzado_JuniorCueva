import XCTest
@testable import LaboralPeru

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
}
