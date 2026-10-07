// Desarrollado por: Junior Cueva
import UIKit

class Producto {
    let nombre: String
    let precio: Double
    var stock: Int

    init(nombre: String, precio: Double, stock: Int) {
        self.nombre = nombre
        self.precio = precio
        self.stock = stock
    }
}

class ItemCarrito {
    let producto: Producto
    var cantidad: Int
    init(producto: Producto, cantidad: Int) {
        self.producto = producto
        self.cantidad = cantidad
    }
    func subtotal() -> Double { producto.precio * Double(cantidad) }
}

class CarritoModel {
    var items: [ItemCarrito] = []
    func agregar(producto: Producto, cantidad: Int) -> Bool {
        if cantidad <= 0 { return false }
        let existente = items.first { $0.producto === producto }
        let actual = existente?.cantidad ?? 0
        if actual + cantidad > producto.stock { return false }
        if let existente = existente { existente.cantidad += cantidad }
        else { items.append(ItemCarrito(producto: producto, cantidad: cantidad)) }
        return true
    }
    func subtotal() -> Double { items.reduce(0) { $0 + $1.subtotal() } }
    func porcentajeDescuento() -> Double {
        let monto = subtotal()
        if monto >= 5000 { return 0.15 }
        if monto >= 2000 { return 0.10 }
        if monto >= 500 { return 0.05 }
        return 0
    }
    func descuento() -> Double { subtotal() * porcentajeDescuento() }
    func base() -> Double { subtotal() - descuento() }
    func igv() -> Double { base() * 0.18 }
    func total() -> Double { base() + igv() }
    func cantidadTotal() -> Int { items.reduce(0) { $0 + $1.cantidad } }
    func vaciar() { items.removeAll() }
    func categoria() -> String {
        switch Int(subtotal()) {
        case ..<500: return "Regular"
        case 500..<2000: return "Frecuente"
        case 2000..<5000: return "VIP"
        default: return "Premium"
        }
    }
}
