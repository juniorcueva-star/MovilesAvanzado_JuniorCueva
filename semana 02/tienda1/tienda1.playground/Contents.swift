import Foundation

print("Nombre del producto:")
let producto = readLine() ?? ""

print("Precio unitario:")
let precioUnit = Double(readLine() ?? "0") ?? 0.0

print("Cantidad:")
let cantidad = Int(readLine() ?? "0") ?? 0

let montoTotalCompra = precioUnit * Double(cantidad)

print("\n-----------------------------------")
print("MONTO TOTAL DE LA COMPRA: S/ \(String(format: "%.2f", montoTotalCompra))")
print("-------------------------------------")


print("\nElige el plan de pago (6, 12, 24):")
let planCuotas = Int(readLine() ?? "0") ?? 6

var porcentajeInteres: Double = 0.0

switch planCuotas {
case 6:
    porcentajeInteres = 0.20
case 12:
    porcentajeInteres = 0.40
case 24:
    porcentajeInteres = 0.60
default:
    porcentajeInteres = 0.0
}

let interesMonto = montoTotalCompra * porcentajeInteres
let montoFinal = montoTotalCompra + interesMonto
let montoCuota = montoFinal / Double(planCuotas)


print("\n---------------------------------")
print("            PLAN DE PAGO")
print("-----------------------------------")
print("Producto:      \(producto)")
print("Cuotas:        \(planCuotas) meses")
print("Interes:       S/ \(String(format: "%.2f", interesMonto))")
print("Monto cuota:   S/ \(String(format: "%.2f", montoCuota))")
print("Monto final:   S/ \(String(format: "%.2f", montoFinal))")
print("-------------------------------------")
