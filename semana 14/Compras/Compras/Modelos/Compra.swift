//
//  Compra.swift
//  Compras
//

import Foundation
import SwiftData

/// Estados posibles de una compra. Se guardan como texto en Compra.estado.
enum EstadoCompra {
    static let pendiente = "Pendiente"
    static let aprobada = "Aprobada"
    static let rechazada = "Rechazada"
}

@Model
final class Compra {
    var fecha: Date
    var cantidad: Int
    var costoUnitario: Double
    var igv: Double             // Credito fiscal
    var total: Double           // subtotal + igv
    var alCredito: Bool         // false = contado, true = credito 30 dias
    var vence: Date             // fecha + 30 dias si es al credito
    var estado: String          // Pendiente, Aprobada o Rechazada
    var pagada: Bool
    var motivoRechazo: String?

    // Lado "uno" de las relaciones (el inverso esta en Usuario, Proveedor y Producto)
    var comprador: Usuario?
    var proveedor: Proveedor?
    var producto: Producto?

    init(fecha: Date = .now,
         cantidad: Int,
         costoUnitario: Double,
         igv: Double,
         total: Double,
         alCredito: Bool,
         vence: Date,
         estado: String,
         pagada: Bool,
         comprador: Usuario?,
         proveedor: Proveedor?,
         producto: Producto?) {
        self.fecha = fecha
        self.cantidad = cantidad
        self.costoUnitario = costoUnitario
        self.igv = igv
        self.total = total
        self.alCredito = alCredito
        self.vence = vence
        self.estado = estado
        self.pagada = pagada
        self.motivoRechazo = nil
        self.comprador = comprador
        self.proveedor = proveedor
        self.producto = producto
    }

    var subtotal: Double { Double(cantidad) * costoUnitario }
    var estaPendiente: Bool { estado == EstadoCompra.pendiente }
    var estaAprobada: Bool { estado == EstadoCompra.aprobada }
    var estaRechazada: Bool { estado == EstadoCompra.rechazada }

    /// Cuenta por pagar: aprobada, al credito y sin pagar
    var esPorPagar: Bool { estaAprobada && alCredito && !pagada }

    /// VENCIDA: por pagar y la fecha de vencimiento ya paso
    func estaVencida(hoy: Date = .now) -> Bool { esPorPagar && vence < hoy }
}
