import Foundation

// Docente : Juan León S.
// Alumno  : Junior Cueva
// Curso   : Programación en Móviles Avanzado
// Lab 02  : Estructuras Condicionales y Bucles

// ===== EJERCICIO 1: CONDICIONALES =====

// Ejemplo 
let nota = 15.0
if nota >= 13.0 {
    print("Aprobado con \(nota)")
} else {
    print("Desaprobado con \(nota)")
}

// --- TODO 1: Validar si una persona es mayor de edad ---
let edad = 17
if edad >= 18 {
    print("Es mayor de edad")
} else {
    print("Es menor de edad")
}

// --- TODO 2: Clasificar una nota con else if ---
// Categorías: Excelente (18-20), Bueno (15-17),
//             Aprobado (13-14), Desaprobado (0-12)
let miNota = 16.0
if miNota >= 18 {
    print("Excelente")
} else if miNota >= 15 {
    print("Bueno")
} else if miNota >= 13 {
    print("Aprobado")
} else {
    print("Desaprobado")
}

// --- TODO 3: Verificar si un número es positivo, negativo o cero ---
let numero = -5
if numero > 0 {
    print("El número es positivo")
} else if numero < 0 {
    print("El número es negativo")
} else {
    print("El número es cero")
}



// corregir errores 

// ===== FIX: Encuentra y corrige los 3 errores =====

// respuesta: falta de llaves de apertura { en el else if
let temperatura = 35
if temperatura > 30 {
    print("Hace calor")
} else if temperatura > 20 {
    print("Clima agradable")
} else {
    print("Hace frío")
}


// FIX 2: 
// respuesta : agregamos el igual  para no excluir al saldo exacto tambien cambiamos el orden del saldo menos compra  

let saldo = 100.0
let compra = 150.0
if saldo >= compra {
    print("Compra realizada")
} else {
    print("Saldo insuficiente: te faltan \(compra - saldo)")
}


// FIX 3: 
// respuesta: la hora 25 no existe ,se corrigio a un valor valido de 0 a 23

let hora = 20
if hora >= 0 && hora < 12 {
    print("Buenos días")
} else if hora >= 12 && hora < 18 {
    print("Buenas tardes")
} else if hora >= 18 && hora <= 23 {
    print("Buenas noches")
} else {
    print("Hora inválida")
}




// ===== PREDICT: ¿Qué imprime cada bloque? =====

let x = 10
if x > 5 && x < 20 {
    print("Dentro del rango")
} else {
    print("Fuera del rango")
} 

let y = 15
if y > 20 {
    print("Mayor que 20")
} else if y > 10 {
    print("Mayor que 10")
} else if y > 5 {
    print("Mayor que 5")
} 


let esLunes = true
let llueve = false
if esLunes && llueve {
    print("Lunes lluvioso")
} else if esLunes || llueve {
    print("Es lunes O llueve")
} else {
    print("Ni lunes ni llueve")
} 