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


// ===== EJERCICIO 2: SWITCH =====

// --- Ejemplo (ya resuelto): ---
let diaSemana = 3
switch diaSemana {
case 1: print("Lunes")
case 2: print("Martes")
case 3: print("Miércoles")
case 4: print("Jueves")
case 5: print("Viernes")
case 6: print("Sábado")
case 7: print("Domingo")
default: print("Día inválido")
}

// --- TODO 4: Clasificar nota numérica a letra ---
let notaSwitch = 16
switch notaSwitch {
case 18...20: print("A - Excelente")
case 15...17: print("B - Bueno")
case 13...14: print("C - Aprobado")
case 11...12: print("D - Desaprobado")
case 0...10: print("F - Reprobado")
default: print("Nota inválida")
}


// --- TODO 5: Calculadora simple con switch ---
let num1 = 20.0
let num2 = 5.0
let operacion = "+"
switch operacion {
case "+": print("Resultado: \(num1 + num2)")
case "-": print("Resultado: \(num1 - num2)")
case "*": print("Resultado: \(num1 * num2)")
case "/":
    if num2 != 0 {
        print("Resultado: \(num1 / num2)")
    } else {
        print("Error: no se puede dividir entre cero")
    }
default: print("Operación no válida")
}


// --- TODO 6: Categoría de producto por precio ---
// let precio = 350.0

// Categorías: Económico (0-99), Medio (100-499),
//	Premium (500-999), Lujo (1000+)
// Usa switch con rangos para clasificar

let precio = 350.0
switch precio {
case 0..<100: print("Económico")
case 100..<500: print("Medio")
case 500..<1000: print("Premium")
case 1000...: print("Lujo")
default: print("Precio inválido")
}


// 2.2 predicciones
//===== PREDICT: ¿Qué imprime? =====

let mes = 2
switch mes {
case 1, 3, 5, 7, 8, 10, 12: print("31 días")
case 4, 6, 9, 11: print("30 días")
case 2: print("28 o 29 días")
default: print("Mes inválido")
} 

let letra: Character = "a"
switch letra {
case "a", "e", "i", "o", "u": print("Vocal")
default: print("Consonante")
} 

// ejercecicio 3 

// 3.1 Completar bucles for-in

// --- Ejemplo (ya resuelto): ---
for i in 1...5 {
    print("Número: \(i)")
}

// --- TODO 7: Tabla de multiplicar del 7 ---
for i in 1...12 {
    print("7 x \(i) = \(7 * i)")
}

// --- TODO 8: Sumatoria del 1 al 100 ---
var suma = 0
for i in 1...100 {
    suma = suma + i
}
print("La suma del 1 al 100 es: \(suma)")

// --- TODO 9: Calcular el factorial de 8 ---
var factorial = 1
for i in 1...8 {
    factorial = factorial * i
}
print("8! = \(factorial)")

// --- TODO 10: Patrón de asteriscos ---
for i in 1...5 {
    print(String(repeating: "*", count: i))
}


// 3.2 Corregir bucles
// ===== FIX: Encuentra los 2 errores =====

// FIX 4: La condición i % 2 == 1 daba impares. Los pares son i % 2 == 0
// Se quiere imprimir los números pares del 2 al 20:
for i in 1...20 {
    if i % 2 == 0 {
        print(i)
    }
}

// FIX 5: El for-in solo cuenta hacia adelante. Se usa stride para ir en reversa
// Se quiere contar del 10 al 1 (cuenta regresiva):
for i in stride(from: 10, through: 1, by: -1) {
    print(i)
}
  

// 3.3  Predicciones


var total = 0
for i in 1...5 {
    total += i
}
print(total) 

var texto = ""
for _ in 1...3 {
    texto += "Hola "
}
print(texto) 