//
//  Proveedor.swift
//  Compras
//

import Foundation
import SwiftData

@Model
final class Proveedor {
    var nombre: String
    var ruc: String

    // Un proveedor tiene muchas compras. .deny: no se borra si tiene compras.
    @Relationship(deleteRule: .deny, inverse: \Compra.proveedor)
    var compras: [Compra] = []

    init(nombre: String, ruc: String) {
        self.nombre = nombre
        self.ruc = ruc
    }
}
