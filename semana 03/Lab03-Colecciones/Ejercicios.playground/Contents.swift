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
