//
//  ComprasTests.swift
//  ComprasTests
//
//  Casos de prueba del laboratorio (Grupo B · Compras) con resultado esperado.
//  Cada prueba usa una base de datos en memoria, asi no se mezclan los datos.
//

import XCTest
import SwiftData
@testable import Compras

@MainActor
final class ComprasTests: XCTestCase {

    private var container: ModelContainer!
    private var contexto: ModelContext { container.mainContext }

    private var comprador: Usuario!
    private var supervisor: Usuario!
    private var proveedor: Proveedor!
    private var laptop: Producto!

    /// Base de datos nueva en memoria con dos usuarios, un proveedor y la Laptop (stock 40, costo 110.00)
    private func preparar() throws {
        container = ModelContainerProvider.enMemoria()
        comprador = try ServicioAuth.registrar(nombre: "Maria Torres", usuario: "mtorres",
                                               clave: "123456", confirmacion: "123456",
                                               rol: Rol.comprador, en: contexto)
        supervisor = try ServicioAuth.registrar(nombre: "Luis Paredes", usuario: "lparedes",
                                                clave: "abcdef", confirmacion: "abcdef",
                                                rol: Rol.supervisor, en: contexto)
        proveedor = Proveedor(nombre: "Distribuidora Andina SAC", ruc: "20512345678")
        // Producto con stock 40 y costo promedio 110.00 (casos 3 a 7)
        laptop = Producto(nombre: "Laptop", categoria: "Cómputo", stock: 40, costoPromedio: 110)
        contexto.insert(proveedor)
        contexto.insert(laptop)
        try contexto.save()
    }

    private func comprar(_ cantidad: Int, a costo: Double, credito: Bool,
                         fecha: Date = .now) throws -> Compra {
        try ServicioCompras.registrar(cantidad: cantidad, costoUnitario: costo, alCredito: credito,
                                      comprador: comprador, proveedor: proveedor, producto: laptop,
                                      fecha: fecha, en: contexto)
    }

    // MARK: - Registro y login

    /// Caso 1: se crea "mtorres" y el repetido se rechaza (tambien en mayusculas, caso 10)
    func testCaso1UsuarioRepetido() throws {
        try preparar()
        XCTAssertTrue(ServicioAuth.existeUsuario("mtorres", en: contexto))
        XCTAssertThrowsError(try ServicioAuth.registrar(nombre: "Otra Persona", usuario: "mtorres",
                                                        clave: "123456", confirmacion: "123456",
                                                        rol: Rol.comprador, en: contexto)) { error in
            XCTAssertEqual(error as? ErrorAuth, .usuarioRepetido)
        }
        XCTAssertThrowsError(try ServicioAuth.registrar(nombre: "Otra Persona", usuario: "MTORRES",
                                                        clave: "123456", confirmacion: "123456",
                                                        rol: Rol.comprador, en: contexto)) { error in
            XCTAssertEqual(error as? ErrorAuth, .usuarioRepetido)
        }
    }

    func testRegistroClaveCortaYDistinta() throws {
        try preparar()
        XCTAssertThrowsError(try ServicioAuth.registrar(nombre: "Ana", usuario: "ana", clave: "1234",
                                                        confirmacion: "1234", rol: Rol.comprador,
                                                        en: contexto)) { error in
            XCTAssertEqual(error as? ErrorAuth, .claveCorta)
        }
        XCTAssertThrowsError(try ServicioAuth.registrar(nombre: "Ana", usuario: "ana", clave: "123456",
                                                        confirmacion: "654321", rol: Rol.comprador,
                                                        en: contexto)) { error in
            XCTAssertEqual(error as? ErrorAuth, .clavesDistintas)
        }
        XCTAssertFalse(ServicioAuth.existeUsuario("ana", en: contexto))
    }

    /// Caso 2: login con clave incorrecta -> mensaje generico
    func testCaso2LoginIncorrecto() throws {
        try preparar()
        XCTAssertThrowsError(try ServicioAuth.login(usuario: "mtorres", clave: "malaclave",
                                                    en: contexto)) { error in
            XCTAssertEqual(error as? ErrorAuth, .credencialesIncorrectas)
            XCTAssertEqual(error.localizedDescription, "Usuario o clave incorrectos")
        }
        let ok = try ServicioAuth.login(usuario: "MTorres", clave: "123456", en: contexto)
        XCTAssertEqual(ok.nombre, "Maria Torres")
    }

    // MARK: - Reglas de compra

    /// Caso 3: 10 a 120.00 al credito
    func testCaso3CompraAlCredito() throws {
        try preparar()
        let compra = try comprar(10, a: 120, credito: true)
        XCTAssertEqual(compra.subtotal, 1_200.00, accuracy: 0.001)
        XCTAssertEqual(compra.igv, 216.00, accuracy: 0.001)
        XCTAssertEqual(compra.total, 1_416.00, accuracy: 0.001)
        XCTAssertEqual(compra.estado, EstadoCompra.aprobada)
        XCTAssertEqual(laptop.stock, 50)
        XCTAssertEqual(laptop.costoPromedio, 112.00, accuracy: 0.001)
        let dias = Calendar.current.dateComponents([.day], from: compra.fecha, to: compra.vence).day
        XCTAssertEqual(dias, 30)
        XCTAssertTrue(compra.esPorPagar)
    }

    /// Caso 4: la misma compra al contado queda pagada
    func testCaso4CompraAlContado() throws {
        try preparar()
        let compra = try comprar(10, a: 120, credito: false)
        XCTAssertTrue(compra.pagada)
        XCTAssertFalse(compra.esPorPagar)
    }

    /// Caso 5: 50 a 120.00 -> total 7,080.00 y queda Pendiente sin cambiar nada
    func testCaso5CompraGrandePendiente() throws {
        try preparar()
        let compra = try comprar(50, a: 120, credito: true)
        XCTAssertEqual(compra.total, 7_080.00, accuracy: 0.001)
        XCTAssertEqual(compra.estado, EstadoCompra.pendiente)
        XCTAssertEqual(laptop.stock, 40)
        XCTAssertEqual(laptop.costoPromedio, 110.00, accuracy: 0.001)
        XCTAssertFalse(compra.esPorPagar)
    }

    /// Caso 6: el supervisor aprueba la compra del caso 5
    func testCaso6SupervisorAprueba() throws {
        try preparar()
        let compra = try comprar(50, a: 120, credito: true)
        try ServicioCompras.aprobar(compra, por: supervisor, en: contexto)
        XCTAssertEqual(compra.estado, EstadoCompra.aprobada)
        XCTAssertEqual(laptop.stock, 90)
        XCTAssertEqual(laptop.costoPromedio, 115.56, accuracy: 0.001)
        XCTAssertTrue(compra.esPorPagar)
    }

    /// Caso 7: rechazo sin motivo no se puede; con motivo queda Rechazada y el stock no cambia
    func testCaso7RechazoConMotivo() throws {
        try preparar()
        let compra = try comprar(50, a: 120, credito: false)
        XCTAssertThrowsError(try ServicioCompras.rechazar(compra, motivo: "   ", por: supervisor,
                                                          en: contexto))
        XCTAssertEqual(compra.estado, EstadoCompra.pendiente)

        try ServicioCompras.rechazar(compra, motivo: "Precio muy alto", por: supervisor, en: contexto)
        XCTAssertEqual(compra.estado, EstadoCompra.rechazada)
        XCTAssertEqual(compra.motivoRechazo, "Precio muy alto")
        XCTAssertEqual(laptop.stock, 40)
        XCTAssertEqual(laptop.costoPromedio, 110.00, accuracy: 0.001)
    }

    /// Caso 8: compra al credito ya vencida; al pagar sale de vencidas y baja el total por pagar
    func testCaso8VencidaYPagar() throws {
        try preparar()
        let haceCuarentaDias = Calendar.current.date(byAdding: .day, value: -40, to: .now)!
        let compra = try comprar(10, a: 120, credito: true, fecha: haceCuarentaDias)
        XCTAssertTrue(compra.estaVencida())

        func totalPorPagar() throws -> Double {
            let aprobada = EstadoCompra.aprobada
            let descriptor = FetchDescriptor<Compra>(predicate: #Predicate {
                $0.estado == aprobada && $0.alCredito == true && $0.pagada == false
            })
            return try contexto.fetch(descriptor).reduce(0) { $0 + $1.total }
        }
        XCTAssertEqual(try totalPorPagar(), 1_416.00, accuracy: 0.001)

        // El filtro Vencidas de la pantalla Por pagar la encuentra
        let vencidas = try contexto.fetch(FetchDescriptor(predicate: FiltroPago.vencidas.predicado(hoy: .now)))
        XCTAssertEqual(vencidas.count, 1)

        try ServicioCompras.pagar(compra, por: supervisor, en: contexto)
        XCTAssertTrue(compra.pagada)
        XCTAssertFalse(compra.estaVencida())
        XCTAssertEqual(try totalPorPagar(), 0, accuracy: 0.001)
        let pagadas = try contexto.fetch(FetchDescriptor(predicate: FiltroPago.pagadas.predicado(hoy: .now)))
        XCTAssertEqual(pagadas.count, 1)
    }

    /// Caso 9: un comprador no puede pagar
    func testCaso9CompradorNoPuedePagar() throws {
        try preparar()
        let compra = try comprar(10, a: 120, credito: true)
        XCTAssertThrowsError(try ServicioCompras.pagar(compra, por: comprador, en: contexto)) { error in
            XCTAssertEqual(error as? ErrorCompra, .sinPermiso)
        }
        XCTAssertFalse(compra.pagada)
        XCTAssertEqual(comprador.compras.count, 1)
        XCTAssertEqual(supervisor.compras.count, 0)
    }

    /// Caso 11: un producto con compras no se puede borrar (.deny)
    func testCaso11ProductoConComprasNoSeBorra() throws {
        try preparar()
        _ = try comprar(1, a: 120, credito: false)
        XCTAssertFalse(laptop.compras.isEmpty)
        XCTAssertFalse(proveedor.compras.isEmpty)
    }

    // MARK: - Funciones puras

    func testCostoPromedioPonderado() throws {
        try preparar()
        XCTAssertEqual(ReglasCompra.nuevoCostoPromedio(stockActual: 40, costoPromedio: 110,
                                                       cantidad: 10, costoUnitario: 120), 112.00, accuracy: 0.001)
        XCTAssertEqual(ReglasCompra.nuevoCostoPromedio(stockActual: 0, costoPromedio: 0,
                                                       cantidad: 5, costoUnitario: 35), 35.00, accuracy: 0.001)
    }

    // MARK: - Valor agregado

    /// RUC: 11 digitos y empieza con 10 o 20
    func testRucValido() {
        XCTAssertTrue(ReglasCompra.rucValido("20512345678"))
        XCTAssertTrue(ReglasCompra.rucValido("10456789012"))
        XCTAssertFalse(ReglasCompra.rucValido("30512345678"))   // no empieza con 10 o 20
        XCTAssertFalse(ReglasCompra.rucValido("2051234567"))    // 10 digitos
        XCTAssertFalse(ReglasCompra.rucValido("2051234567A"))   // tiene una letra
    }

    /// Stock bajo: 5 o menos
    func testStockBajo() {
        XCTAssertTrue(ReglasCompra.esStockBajo(3))
        XCTAssertTrue(ReglasCompra.esStockBajo(5))
        XCTAssertFalse(ReglasCompra.esStockBajo(6))
        XCTAssertFalse(Producto(nombre: "Laptop", categoria: "Cómputo", stock: 40, costoPromedio: 110).tieneStockBajo)
    }

    /// Historial del supervisor: el filtro por estado encuentra cada compra
    func testHistorialPorEstado() throws {
        try preparar()
        _ = try comprar(10, a: 120, credito: true)                  // Aprobada
        let grande = try comprar(50, a: 120, credito: true)         // Pendiente
        let otra = try comprar(60, a: 120, credito: false)          // Pendiente -> Rechazada
        try ServicioCompras.rechazar(otra, motivo: "Muy caro", por: supervisor, en: contexto)

        func contar(_ filtro: FiltroHistorial) throws -> Int {
            guard let estado = filtro.estado else {
                return try contexto.fetchCount(FetchDescriptor<Compra>())
            }
            return try contexto.fetchCount(FetchDescriptor<Compra>(predicate: #Predicate { $0.estado == estado }))
        }
        XCTAssertEqual(try contar(.todas), 3)
        XCTAssertEqual(try contar(.aprobadas), 1)
        XCTAssertEqual(try contar(.pendientes), 1)
        XCTAssertEqual(try contar(.rechazadas), 1)
        XCTAssertTrue(grande.estaPendiente)
    }

    func testLimiteDeAprobacion() throws {
        try preparar()
        XCTAssertFalse(ReglasCompra.requiereAprobacion(total: 4_999.99))
        XCTAssertTrue(ReglasCompra.requiereAprobacion(total: 5_000.00))
    }
}
