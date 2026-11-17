//
//  Producto.swift
//  Compras
//

import Foundation
import SwiftData

@Model
final class Producto {
    var nombre: String
    var categoria: String
    var stock: Int
    var costoPromedio: Double

    // Un producto aparece en muchas compras. .deny: no se borra si tiene compras.
    @Relationship(deleteRule: .deny, inverse: \Compra.producto)
    var compras: [Compra] = []

    init(nombre: String, categoria: String, stock: Int, costoPromedio: Double) {
        self.nombre = nombre
        self.categoria = categoria
        self.stock = stock
        self.costoPromedio = costoPromedio
    }

    /// Valor del inventario = stock x costo promedio (calculado, no se guarda)
    var valorInventario: Double { Double(stock) * costoPromedio }
}
