import XCTest

// Ejecuta las mismas pruebas de Xcode desde Swift para Windows.
XCTMain([testCase([
    ("CTS completo", LaboralPeruTests.testCTSSemestreCompleto),
    ("CTS días y validaciones", LaboralPeruTests.testCTSDiasYValidaciones),
    ("Gratificación proporcional EPS", LaboralPeruTests.testGratificacionProporcionalEPS),
    ("Gratificación completa y cero meses", LaboralPeruTests.testGratificacionCompletaYCeroMeses),
    ("ONP y gratificación de julio", LaboralPeruTests.testONPOctubreYGratificacionJulio),
    ("AFP flujo y saldo", LaboralPeruTests.testAFPFlujoYSaldo),
    ("Límites de horas y EsSalud mínimo", LaboralPeruTests.testLimitesHorasYMinimoEsSalud),
    ("Tramos del impuesto anual", LaboralPeruTests.testTramosImpuestoAnual),
    ("Retenciones y conciliación anual", LaboralPeruTests.testRetencionesYConciliacionAnual),
    ("Entrada decimal", LaboralPeruTests.testEntradaDecimal)
])])
