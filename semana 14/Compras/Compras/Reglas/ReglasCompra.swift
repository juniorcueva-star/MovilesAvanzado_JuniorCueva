//
//  ReglasCompra.swift
//  Compras
//
//  Reglas de negocio del caso Compras. Son funciones puras: no tocan la base de datos,
//  por eso se pueden probar con numeros (ver ComprasTests).
//

import Foundation

enum ReglasCompra {

    static let tasaIGV = 0.18               // 18 %
    static let limiteAprobacion = 5_000.0   // Desde S/ 5,000 necesita aprobacion
    static let diasCredito = 30
    static let stockMinimo = 5              // Stock bajo: 5 unidades o menos

    /// Redondea a 2 decimales (centimos)
    static func redondear(_ valor: Double) -> Double {
        (valor * 100).rounded() / 100
    }

    /// Subtotal = cantidad x costo unitario
    static func subtotal(cantidad: Int, costoUnitario: Double) -> Double {
        redondear(Double(cantidad) * costoUnitario)
    }

    /// IGV = 18 % del subtotal. Es credito fiscal para la empresa.
    static func igv(subtotal: Double) -> Double {
        redondear(subtotal * tasaIGV)
    }

    /// Total = subtotal + IGV
    static func total(subtotal: Double, igv: Double) -> Double {
        redondear(subtotal + igv)
    }

    /// Una compra desde S/ 5,000 queda Pendiente; si es menor, Aprobada al instante.
    static func requiereAprobacion(total: Double) -> Bool {
        total >= limiteAprobacion
    }

    static func estadoInicial(total: Double) -> String {
        requiereAprobacion(total: total) ? EstadoCompra.pendiente : EstadoCompra.aprobada
    }

    /// Costo promedio ponderado:
    /// nuevo = (stock actual x costo promedio + cantidad x costo unitario) / (stock actual + cantidad)
    static func nuevoCostoPromedio(stockActual: Int, costoPromedio: Double,
                                   cantidad: Int, costoUnitario: Double) -> Double {
        let unidades = stockActual + cantidad
        guard unidades > 0 else { return costoUnitario }
        let valor = Double(stockActual) * costoPromedio + Double(cantidad) * costoUnitario
        return redondear(valor / Double(unidades))
    }

    /// Credito 30 dias: vence a los 30 dias. Contado: vence el mismo dia (ya esta pagada).
    static func fechaVencimiento(desde fecha: Date, alCredito: Bool) -> Date {
        guard alCredito else { return fecha }
        return Calendar.current.date(byAdding: .day, value: diasCredito, to: fecha) ?? fecha
    }

    /// RUC peruano: 11 digitos y empieza con 10 (persona natural) o 20 (empresa)
    static func rucValido(_ ruc: String) -> Bool {
        ruc.count == 11
            && ruc.allSatisfy(\.isNumber)
            && (ruc.hasPrefix("10") || ruc.hasPrefix("20"))
    }

    /// Stock bajo: el producto tiene 5 unidades o menos
    static func esStockBajo(_ stock: Int) -> Bool {
        stock <= stockMinimo
    }
}

/// Resultado del calculo que se muestra en la pantalla de compra (B5)
struct CalculoCompra {
    let subtotal: Double
    let igv: Double
    let total: Double

    init(cantidad: Int, costoUnitario: Double) {
        subtotal = ReglasCompra.subtotal(cantidad: cantidad, costoUnitario: costoUnitario)
        igv = ReglasCompra.igv(subtotal: subtotal)
        total = ReglasCompra.total(subtotal: subtotal, igv: igv)
    }

    var requiereAprobacion: Bool { ReglasCompra.requiereAprobacion(total: total) }
}
