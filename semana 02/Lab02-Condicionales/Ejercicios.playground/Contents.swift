import Foundation

// Docente : Juan León S.
// Alumno  : Junior Cueva
// Curso   : Programación en Móviles Avanzado
// Lab 02  : Estructuras Condicionales y Bucles

// ===== EJERCICIO 6: CARRITO MEJORADO (asistido por IA) =====

let prod1 = "Laptop"                                  // Nombre del producto 1
let precio1 = 3500.0                                  // Precio unitario del producto 1 en soles
let cant1 = 1                                         // Unidades compradas del producto 1

let prod2 = "Mouse"                                   // Nombre del producto 2
let precio2 = 45.50                                   // Precio unitario del producto 2 en soles
let cant2 = 2                                         // Unidades compradas del producto 2

let prod3 = "USB Cable"                               // Nombre del producto 3
let precio3 = 15.00                                   // Precio unitario del producto 3 en soles
let cant3 = 3                                         // Unidades compradas del producto 3

let cupon = "DESCUENTO20"                             // Codigo de cupon ingresado por el cliente

// --- Requisito 5: Validacion de datos ---
var datosValidos = true                               // Bandera que indica si los datos pasan la validacion

if precio1 < 0 || precio2 < 0 || precio3 < 0 {        // Verifica si algun precio es negativo usando OR
    print("Error: hay un precio negativo")            // Muestra el mensaje de error de precio
    datosValidos = false                              // Marca los datos como invalidos
}

if cant1 == 0 || cant2 == 0 || cant3 == 0 {           // Verifica si alguna cantidad es cero usando OR
    print("Error: hay una cantidad en cero")          // Muestra el mensaje de error de cantidad
    datosValidos = false                              // Marca los datos como invalidos
}

if datosValidos {                                     // Solo procesa el carrito si la validacion paso

    // --- Requisito 1: Descuento por cantidad (3 o mas unidades = 5% extra) ---
    var sub1 = precio1 * Double(cant1)                // Subtotal base del producto 1 convirtiendo Int a Double
    if cant1 >= 3 {                                   // Comprueba si se compraron 3 o mas unidades
        sub1 = sub1 - (sub1 * 0.05)                   // Resta el 5% de descuento por volumen al subtotal
    }

    var sub2 = precio2 * Double(cant2)                // Subtotal base del producto 2
    if cant2 >= 3 {                                   // Comprueba si el producto 2 califica al descuento
        sub2 = sub2 - (sub2 * 0.05)                   // Aplica el 5% de descuento por volumen
    }

    var sub3 = precio3 * Double(cant3)                // Subtotal base del producto 3
    if cant3 >= 3 {                                   // El producto 3 tiene 3 unidades, si califica
        sub3 = sub3 - (sub3 * 0.05)                   // Aplica el 5% de descuento por volumen
    }

    let subtotalGeneral = sub1 + sub2 + sub3          // Suma los tres subtotales ya descontados

    // --- Descuento escalonado por monto de compra ---
    var porcentajeDescuento = 0.0                     // Porcentaje de descuento inicial en cero
    if subtotalGeneral >= 5000 {                      // Tramo mas alto de compra
        porcentajeDescuento = 0.15                    // Asigna 15% de descuento
    } else if subtotalGeneral >= 2000 {               // Tramo intermedio alto
        porcentajeDescuento = 0.10                    // Asigna 10% de descuento
    } else if subtotalGeneral >= 500 {                // Tramo intermedio bajo
        porcentajeDescuento = 0.05                    // Asigna 5% de descuento
    }

    let descuento = subtotalGeneral * porcentajeDescuento   // Calcula el monto en soles del descuento
    var totalParcial = subtotalGeneral - descuento          // Resta el descuento al subtotal general

    // --- Requisito 2: Cupon de descuento ---
    var descuentoCupon = 0.0                          // Monto descontado por el cupon, inicia en cero
    if cupon == "DESCUENTO20" {                       // Compara el cupon con el codigo valido
        descuentoCupon = totalParcial * 0.20          // Calcula el 20% adicional sobre el total parcial
        totalParcial = totalParcial - descuentoCupon  // Descuenta ese monto del total parcial
    }

    // --- Requisito 3: Envio gratis si supera S/. 3000 ---
    var costoEnvio = 25.00                            // Costo de envio por defecto
    if totalParcial > 3000 {                          // Verifica si el total supera el umbral de envio gratis
        costoEnvio = 0.0                              // El envio pasa a ser gratuito
    }

    let igv = totalParcial * 0.18                     // Calcula el IGV del 18% sobre el total parcial
    let totalFinal = totalParcial + igv + costoEnvio  // Suma total parcial, IGV y envio

    // --- Requisito 4: Puntos de fidelidad ---
    let puntos = Int(totalFinal / 100)                // Un punto por cada 100 soles, Int trunca decimales

    var separador = ""                                // Cadena vacia donde se construira la linea separadora
    for _ in 1...40 {                                 // Repite 40 veces sin usar el contador
        separador += "="                              // Concatena un signo igual en cada vuelta
    }

    print(separador)                                              // Linea superior del ticket
    print("        TICKET DE COMPRA MEJORADO")                    // Titulo del ticket
    print(separador)                                              // Separador bajo el titulo
    print("\(prod1) x\(cant1)   S/. \(sub1)")                     // Detalle del producto 1
    print("\(prod2) x\(cant2)    S/. \(sub2)")                    // Detalle del producto 2
    print("\(prod3) x\(cant3) S/. \(sub3)")                       // Detalle del producto 3
    print(separador)                                              // Separador antes de los totales
    print("Subtotal:          S/. \(subtotalGeneral)")            // Muestra el subtotal general
    print("Descuento monto:  -S/. \(descuento)")                  // Muestra el descuento por monto
    print("Cupon aplicado:   -S/. \(descuentoCupon)")             // Muestra el descuento del cupon
    print("IGV (18%):         S/. \(igv)")                        // Muestra el impuesto calculado
    print("Envio:             S/. \(costoEnvio)")                 // Muestra el costo de envio
    print(separador)                                              // Separador antes del total
    print("TOTAL:             S/. \(totalFinal)")                 // Muestra el total a pagar
    print("Puntos ganados:    \(puntos)")                         // Muestra los puntos de fidelidad
    print(separador)                                              // Linea inferior del ticket
}