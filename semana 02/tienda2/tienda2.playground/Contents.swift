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

// ===== PASO 2: PLAN DE PAGO E INTERESES =====

print("\nElige el plan de pago (6, 12, 24):")
var planCuotas = Int(readLine() ?? "0") ?? 6

var porcentajeInteres = 0.0

switch planCuotas {
case 6:
    porcentajeInteres = 0.20
case 12:
    porcentajeInteres = 0.40
case 24:
    porcentajeInteres = 0.60
default:
    print("Plan no valido. Se asigna el plan de 6 meses.")
    planCuotas = 6
    porcentajeInteres = 0.20
}

let interesMonto = montoTotalCompra * porcentajeInteres
let montoFinal = montoTotalCompra + interesMonto
let montoCuota = montoFinal / Double(planCuotas)

print("\n-------------------------------------")
print("            PLAN DE PAGO")
print("-------------------------------------")
print("Producto:         \(producto)")
print("Cuotas:           \(planCuotas) meses")
print("Interes (\(Int(porcentajeInteres * 100))%):    S/ \(String(format: "%.2f", interesMonto))")
print("Monto compra:     S/ \(String(format: "%.2f", montoTotalCompra))")
print("Monto financiado: S/ \(String(format: "%.2f", montoFinal))")
print("Cuota mensual:    S/ \(String(format: "%.2f", montoCuota))")
print("-------------------------------------")


// ===== PASO 3: PAGO ADELANTADO =====

print("\nEn que mes desea adelantar un pago? (0 = ninguno)")
var mesAdelanto = Int(readLine() ?? "0") ?? 0

var montoAdelanto = 0.0

if mesAdelanto < 0 || mesAdelanto > planCuotas {
    print("Mes fuera del plan. No se registra adelanto.")
    mesAdelanto = 0
}

if mesAdelanto > 0 {
    print("Monto a adelantar en el mes \(mesAdelanto):")
    montoAdelanto = Double(readLine() ?? "0") ?? 0.0

    if montoAdelanto <= 0 {
        print("Monto invalido. No se registra adelanto.")
        montoAdelanto = 0.0
        mesAdelanto = 0
    } else {
        let totalDelMes = montoCuota + montoAdelanto
        print("\n-------------------------------------")
        print("ADELANTO REGISTRADO EN EL MES \(mesAdelanto)")
        print("Cuota programada: S/ \(String(format: "%.2f", montoCuota))")
        print("Adelanto:         S/ \(String(format: "%.2f", montoAdelanto))")
        print("Total del mes:    S/ \(String(format: "%.2f", totalDelMes))")
        print("-------------------------------------")
    }
} else {
    print("No se registro ningun adelanto.")
}