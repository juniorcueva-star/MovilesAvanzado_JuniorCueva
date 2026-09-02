import Foundation

// ===== PASO 1: DATOS DEL PRODUCTO =====

print("Nombre del producto:")
let producto = readLine() ?? ""

print("Precio unitario:")
let precioUnit = Double(readLine() ?? "0") ?? 0.0

print("Cantidad:")
let cantidad = Int(readLine() ?? "0") ?? 0

let montoTotalCompra = precioUnit * Double(cantidad)

print("\n-------------------------------------")
print("MONTO TOTAL DE LA COMPRA: S/ \(String(format: "%.2f", montoTotalCompra))")
print("-------------------------------------")