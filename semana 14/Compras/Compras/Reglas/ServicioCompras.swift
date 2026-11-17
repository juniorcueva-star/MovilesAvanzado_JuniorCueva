//
//  ServicioCompras.swift
//  Compras
//
//  Operaciones que cambian datos: registrar, aprobar, rechazar y pagar compras.
//

import Foundation
import SwiftData

enum ErrorCompra: LocalizedError {
    case datosIncompletos
    case cantidadInvalida
    case costoInvalido
    case noEstaPendiente
    case motivoVacio
    case noEsPorPagar
    case sinPermiso

    var errorDescription: String? {
        switch self {
        case .datosIncompletos: return "Elige proveedor y producto."
        case .cantidadInvalida: return "La cantidad debe ser mayor que cero."
        case .costoInvalido: return "El costo unitario debe ser mayor que cero."
        case .noEstaPendiente: return "La compra ya no está pendiente."
        case .motivoVacio: return "Escribe el motivo del rechazo."
        case .noEsPorPagar: return "La compra no tiene deuda pendiente."
        case .sinPermiso: return "Solo el supervisor puede hacer esta acción."
        }
    }
}

enum ServicioCompras {

    /// Registra una compra. Si el total es menor a S/ 5,000 queda Aprobada y aplica sus efectos;
    /// si no, queda Pendiente y no cambia stock, costo promedio ni cuentas por pagar.
    @discardableResult
    static func registrar(cantidad: Int,
                          costoUnitario: Double,
                          alCredito: Bool,
                          comprador: Usuario,
                          proveedor: Proveedor?,
                          producto: Producto?,
                          fecha: Date = .now,
                          en contexto: ModelContext) throws -> Compra {
        guard let proveedor, let producto else { throw ErrorCompra.datosIncompletos }
        guard cantidad > 0 else { throw ErrorCompra.cantidadInvalida }
        guard costoUnitario > 0 else { throw ErrorCompra.costoInvalido }

        let calculo = CalculoCompra(cantidad: cantidad, costoUnitario: costoUnitario)
        let compra = Compra(
            fecha: fecha,
            cantidad: cantidad,
            costoUnitario: costoUnitario,
            igv: calculo.igv,
            total: calculo.total,
            alCredito: alCredito,
            vence: ReglasCompra.fechaVencimiento(desde: fecha, alCredito: alCredito),
            estado: ReglasCompra.estadoInicial(total: calculo.total),
            pagada: !alCredito,           // Contado: queda pagada
            comprador: comprador,
            proveedor: proveedor,
            producto: producto
        )
        contexto.insert(compra)

        if compra.estaAprobada {
            aplicarEfectos(de: compra)
        }
        try contexto.save()
        return compra
    }

    /// Efectos de una compra aprobada: costo promedio ponderado y stock
    static func aplicarEfectos(de compra: Compra) {
        guard let producto = compra.producto else { return }
        producto.costoPromedio = ReglasCompra.nuevoCostoPromedio(
            stockActual: producto.stock,
            costoPromedio: producto.costoPromedio,
            cantidad: compra.cantidad,
            costoUnitario: compra.costoUnitario
        )
        producto.stock += compra.cantidad
    }

    /// Vista previa para la pantalla Aprobar (B7): como quedaria el producto si se aprueba
    static func vistaPrevia(de compra: Compra) -> (stockAntes: Int, stockDespues: Int,
                                                   costoAntes: Double, costoDespues: Double) {
        let stock = compra.producto?.stock ?? 0
        let costo = compra.producto?.costoPromedio ?? 0
        let nuevo = ReglasCompra.nuevoCostoPromedio(stockActual: stock, costoPromedio: costo,
                                                    cantidad: compra.cantidad,
                                                    costoUnitario: compra.costoUnitario)
        return (stock, stock + compra.cantidad, costo, nuevo)
    }

    /// El supervisor aprueba: se aplican los efectos
    static func aprobar(_ compra: Compra, por usuario: Usuario, en contexto: ModelContext) throws {
        guard usuario.esSupervisor else { throw ErrorCompra.sinPermiso }
        guard compra.estaPendiente else { throw ErrorCompra.noEstaPendiente }
        compra.estado = EstadoCompra.aprobada
        aplicarEfectos(de: compra)
        try contexto.save()
    }

    /// El supervisor rechaza con un motivo obligatorio: no cambia stock ni costo
    static func rechazar(_ compra: Compra, motivo: String, por usuario: Usuario,
                         en contexto: ModelContext) throws {
        guard usuario.esSupervisor else { throw ErrorCompra.sinPermiso }
        guard compra.estaPendiente else { throw ErrorCompra.noEstaPendiente }
        let texto = motivo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texto.isEmpty else { throw ErrorCompra.motivoVacio }
        compra.estado = EstadoCompra.rechazada
        compra.motivoRechazo = texto
        try contexto.save()
    }

    /// El supervisor paga una compra al credito: sale de Pendientes y pasa a Pagadas
    static func pagar(_ compra: Compra, por usuario: Usuario, en contexto: ModelContext) throws {
        guard usuario.esSupervisor else { throw ErrorCompra.sinPermiso }
        guard compra.esPorPagar else { throw ErrorCompra.noEsPorPagar }
        compra.pagada = true
        try contexto.save()
    }
}
