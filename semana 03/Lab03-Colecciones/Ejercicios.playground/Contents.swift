// Desarrollado por: Junior Cueva
// Docente: Juan Leon - Tecsup
// Laboratorio 03 - Colecciones

import Foundation

// Desarrollado por: Junior Cueva
// ===== EJERCICIO 6: GESTIÓN DE NOTAS (asistido por IA) =====

import Foundation

var registroNotas: [String: [Double]] = [:]                    // Diccionario que asocia cada alumno con su array de 3 notas

print("¿Cuántos alumnos?")                                     // Solicita la cantidad de alumnos a registrar
let cantidadAlumnos = Int(readLine() ?? "") ?? 0               // Lee la cantidad y la convierte a entero, si falla usa 0

for i in 1...cantidadAlumnos {                                 // Repite el registro por cada alumno
    print("\nAlumno \(i) - Nombre:")                           // Pide el nombre del alumno actual
    let nombre = readLine() ?? ""                              // Lee el nombre, si viene nulo usa cadena vacia
    var notas: [Double] = []                                   // Array temporal donde se guardan las 3 notas del alumno
    for j in 1...3 {                                           // Bucle anidado que pide exactamente 3 notas
        print("Nota \(j):")                                    // Indica que numero de nota se esta pidiendo
        let n = Double(readLine() ?? "") ?? 0                  // Lee la nota y la convierte a decimal
        notas.append(n)                                        // Agrega la nota al array temporal
    }
    registroNotas[nombre] = notas                              // Guarda el array completo en el diccionario usando el nombre como clave
}

var sumaGeneral = 0.0                                          // Acumulador de todos los promedios para el promedio general
var totalAprobados = 0                                         // Contador de alumnos con promedio aprobatorio
var notaMasAlta = 0.0                                          // Guarda el promedio mas alto encontrado
var notaMasBaja = 20.0                                         // Guarda el promedio mas bajo, inicia en 20 para que cualquier valor lo reemplace
var alumnoMasAlto = ""                                         // Nombre del alumno con mejor promedio
var alumnoMasBajo = ""                                         // Nombre del alumno con peor promedio

print("\n===== REPORTE INDIVIDUAL =====")                      // Titulo de la seccion de reporte

for (alumno, notas) in registroNotas {                         // Recorre el diccionario obteniendo nombre y array de notas
    var suma = 0.0                                             // Acumulador de las notas de este alumno
    for nota in notas {                                        // Recorre las 3 notas del array
        suma += nota                                           // Suma cada nota al acumulador
    }
    let promedio = suma / Double(notas.count)                  // Divide entre la cantidad de notas, convierte count a Double

    var clasificacion = ""                                     // Variable que guardara la categoria del promedio
    switch promedio {                                          // Evalua el promedio contra rangos
    case 18...20: clasificacion = "Excelente"                  // Rango superior
    case 15..<18: clasificacion = "Bueno"                      // Rango medio alto, excluye el 18
    case 13..<15: clasificacion = "Aprobado"                   // Rango minimo aprobatorio, excluye el 15
    default: clasificacion = "Desaprobado"                     // Cualquier promedio menor a 13
    }

    print("\(alumno): \(notas) → Promedio: \(promedio) → \(clasificacion)")   // Muestra nombre, notas, promedio y clasificacion

    sumaGeneral += promedio                                    // Acumula el promedio para calcular el general
    if promedio >= 13 { totalAprobados += 1 }                  // Incrementa el contador si aprobo

    if promedio > notaMasAlta {                                // Compara si este promedio supera al mayor registrado
        notaMasAlta = promedio                                 // Actualiza el promedio mas alto
        alumnoMasAlto = alumno                                 // Guarda el nombre del alumno
    }
    if promedio < notaMasBaja {                                // Compara si este promedio es menor al minimo registrado
        notaMasBaja = promedio                                 // Actualiza el promedio mas bajo
        alumnoMasBajo = alumno                                 // Guarda el nombre del alumno
    }
}

let promedioGeneral = sumaGeneral / Double(registroNotas.count)              // Divide la suma de promedios entre la cantidad de alumnos
let porcentajeAprobados = Double(totalAprobados) / Double(registroNotas.count) * 100   // Calcula el porcentaje de aprobados

print("\n===== ESTADÍSTICAS =====")                            // Titulo de la seccion de estadisticas
print("Promedio general: \(promedioGeneral)")                  // Muestra el promedio de todos los alumnos
print("Nota más alta: \(notaMasAlta) (\(alumnoMasAlto))")      // Muestra el mejor promedio y su dueño
print("Nota más baja: \(notaMasBaja) (\(alumnoMasBajo))")      // Muestra el peor promedio y su dueño
print("Aprobados: \(totalAprobados) de \(registroNotas.count)")               // Muestra cuantos aprobaron del total
print("Porcentaje de aprobados: \(porcentajeAprobados)%")      // Muestra el porcentaje calculado


// ===== EJERCICIO 7: INVENTARIO CON MENÚ (asistido por IA) =====

var inventarioPrecios: [String: Double] = [:]                  // Diccionario que asocia cada producto con su precio
var inventarioStocks: [String: Int] = [:]                      // Diccionario que asocia cada producto con su stock

print("\n¿Cuántos productos desea registrar?")                 // Solicita la cantidad de productos
let totalProd = Int(readLine() ?? "") ?? 0                     // Lee la cantidad y la convierte a entero

for i in 1...totalProd {                                       // Repite el registro por cada producto
    print("\nProducto \(i) - Nombre:")                         // Pide el nombre del producto actual
    let nombre = readLine() ?? ""                              // Lee el nombre del producto
    print("Precio:")                                           // Pide el precio unitario
    let precio = Double(readLine() ?? "") ?? 0                 // Lee el precio y lo convierte a decimal
    print("Stock:")                                            // Pide las unidades disponibles
    let stock = Int(readLine() ?? "") ?? 0                     // Lee el stock y lo convierte a entero
    inventarioPrecios[nombre] = precio                         // Guarda el precio usando el nombre como clave
    inventarioStocks[nombre] = stock                           // Guarda el stock usando la misma clave
}

var salir = false                                              // Bandera que controla la salida del menu

while !salir {                                                 // Repite el menu mientras la bandera sea falsa
    print("\n===== MENÚ DE INVENTARIO =====")                  // Titulo del menu
    print("1) Ver inventario")                                 // Opcion para listar todo
    print("2) Buscar producto")                                // Opcion para buscar uno especifico
    print("3) Stock bajo")                                     // Opcion para filtrar por stock
    print("4) Valor total")                                    // Opcion para calcular el valor del inventario
    print("5) Salir")                                          // Opcion para terminar el programa
    print("Elija una opción:")                                 // Solicita la eleccion del usuario

    let opcion = Int(readLine() ?? "") ?? 0                    // Lee la opcion y la convierte a entero

    switch opcion {                                            // Evalua la opcion elegida
    case 1:                                                    // Opcion ver inventario
        print("\n===== INVENTARIO =====")                      // Titulo de la lista
        for (nombre, precio) in inventarioPrecios {            // Recorre el diccionario de precios
            if let stock = inventarioStocks[nombre] {          // Busca el stock de ese producto de forma segura
                print("\(nombre) - S/. \(precio) - Stock: \(stock)")   // Muestra nombre, precio y stock
            }
        }
    case 2:                                                    // Opcion buscar producto
        print("\nNombre del producto a buscar:")               // Solicita el nombre a buscar
        let buscado = readLine() ?? ""                         // Lee el nombre ingresado
        if let precio = inventarioPrecios[buscado] {           // Verifica si existe en el diccionario
            let stock = inventarioStocks[buscado] ?? 0         // Obtiene el stock, si no existe usa 0
            print("\(buscado) - S/. \(precio) - Stock: \(stock)")     // Muestra los datos encontrados
        } else {                                               // Si no existe la clave
            print("Producto no encontrado")                    // Informa que no esta registrado
        }
    case 3:                                                    // Opcion stock bajo
        print("\n===== STOCK BAJO (menos de 5) =====")         // Titulo del filtro
        for (nombre, stock) in inventarioStocks {              // Recorre el diccionario de stocks
            if stock < 5 {                                     // Filtra solo los que tienen menos de 5 unidades
                print("\(nombre): \(stock) unidades")          // Muestra el producto y su stock
            }
        }
    case 4:                                                    // Opcion valor total
        var valorTotalInv = 0.0                                // Acumulador del valor del inventario
        for (nombre, precio) in inventarioPrecios {            // Recorre cada producto con su precio
            if let stock = inventarioStocks[nombre] {          // Obtiene el stock correspondiente
                valorTotalInv += precio * Double(stock)        // Multiplica precio por stock y acumula
            }
        }
        print("\nValor total del inventario: S/. \(valorTotalInv)")   // Muestra el valor calculado
    case 5:                                                    // Opcion salir
        salir = true                                           // Cambia la bandera para terminar el bucle
        print("\nSaliendo del sistema...")                     // Mensaje de despedida
    default:                                                   // Cualquier opcion no contemplada
        print("\nOpción no válida")                            // Informa el error al usuario
    }
}
