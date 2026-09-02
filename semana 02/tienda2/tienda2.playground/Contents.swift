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




// ===== PASO 4: CRONOGRAMA DE PAGOS =====

var mesCalendario = 1
var anio = 2026

var saldoPendiente = montoFinal
var mes = 1
var totalPagado = 0.0

print("\n---------------------------------------------------------------")
print("                     CRONOGRAMA DE PAGOS")
print("---------------------------------------------------------------")
print("Mes\tFecha\t\tMonto inicial\tPago\t\tResta x pagar")
print("---------------------------------------------------------------")

while mes <= planCuotas && saldoPendiente > 0 {

    let montoInicialMes = saldoPendiente

    var pagoDelMes = montoCuota

    if mes == mesAdelanto {
        pagoDelMes = pagoDelMes + montoAdelanto
    }

    if pagoDelMes > saldoPendiente {
        pagoDelMes = saldoPendiente
    }

    saldoPendiente = saldoPendiente - pagoDelMes
    totalPagado = totalPagado + pagoDelMes

    let fecha = "\(mesCalendario)/\(anio)"

    print("\(mes)\t\(fecha)\t\t\(String(format: "%.2f", montoInicialMes))\t\t\(String(format: "%.2f", pagoDelMes))\t\t\(String(format: "%.2f", saldoPendiente))")

    mesCalendario = mesCalendario + 1
    if mesCalendario > 12 {
        mesCalendario = 1
        anio = anio + 1
    }

    mes = mes + 1
}

print("---------------------------------------------------------------")
print("Total pagado:  S/ \(String(format: "%.2f", totalPagado))")
print("Meses usados:  \(mes - 1) de \(planCuotas)")
print("---------------------------------------------------------------")