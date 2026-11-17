//
//  DatosEjemplo.swift
//  Compras
//
//  Datos para probar los casos del laboratorio sin escribir todo a mano.
//  Incluye una compra al credito ya vencida (caso 8).
//

import Foundation
import SwiftData

enum DatosEjemplo {

    /// Solo carga si todavia no hay productos (para no duplicar)
    static func puedeCargar(en contexto: ModelContext) -> Bool {
        ((try? contexto.fetchCount(FetchDescriptor<Producto>())) ?? 0) == 0
    }

    static func cargar(usuario: Usuario, en contexto: ModelContext) throws {
        guard puedeCargar(en: contexto) else { return }

        let andina = Proveedor(nombre: "Distribuidora Andina SAC", ruc: "20512345678")
        let lima = Proveedor(nombre: "Importaciones Lima EIRL", ruc: "20654321987")
        contexto.insert(andina)
        contexto.insert(lima)

        // Producto de los casos 3 a 6: stock 40 y costo promedio 110.00
        let laptop = Producto(nombre: "Laptop", categoria: "Cómputo", stock: 40, costoPromedio: 110)
        let mouse = Producto(nombre: "Mouse", categoria: "Accesorios", stock: 8, costoPromedio: 35)
        let monitor = Producto(nombre: "Monitor 24\"", categoria: "Cómputo", stock: 3, costoPromedio: 450)
        [laptop, mouse, monitor].forEach { contexto.insert($0) }
        try contexto.save()

        // Caso 8: compra al credito de hace 40 dias -> vencio hace 10 dias
        let haceCuarentaDias = Calendar.current.date(byAdding: .day, value: -40, to: .now) ?? .now
        try ServicioCompras.registrar(cantidad: 2, costoUnitario: 450, alCredito: true,
                                      comprador: usuario, proveedor: lima, producto: monitor,
                                      fecha: haceCuarentaDias, en: contexto)
    }
}
