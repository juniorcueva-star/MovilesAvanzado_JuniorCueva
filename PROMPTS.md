# Prompts utilizados — Laboratorio 02

## Herramienta de IA utilizada
Claude

## Ejercicio 6 — Carrito mejorado

### Prompt (estructura CTRFE):

CONTEXTO: Soy estudiante de Programacion en Moviles Avanzado. Tengo un carrito de compras en Swift hecho con constantes individuales (prod1, precio1, cant1), sin arrays porque aun no los vemos. Trabajo en un Playground con import Foundation.

TAREA: Mejorar el carrito agregando cinco funcionalidades: descuento del 5% extra al comprar 3 o mas unidades del mismo producto, cupon "DESCUENTO20" que aplica 20% adicional al total, envio gratis si el total supera S/. 3000 y S/. 25 en caso contrario, puntos de fidelidad a razon de 1 punto por cada S/. 100, y validacion que muestre error si algun precio es negativo o alguna cantidad es cero.

RESTRICCIONES: Usar solo condicionales, switch y bucles de la semana 2. No usar arrays, funciones ni estructuras. Cada linea de codigo debe llevar un comentario que explique especificamente que hace.

FORMATO: Codigo Swift completo, listo para pegar en Contents.swift, con comentarios alineados a la derecha.

EJEMPLO: Para el descuento por cantidad esperaba algo como: if cant1 >= 3 { sub1 = sub1 - (sub1 * 0.05) }

### ¿Funcionó a la primera?
Si. El codigo compilo sin errores. Tuve que renombrar algunas constantes para que no chocaran con las que ya tenia declaradas en otros ejercicios del mismo archivo.

### ¿La IA usó algo que no conocías?
Si. Use Double(cant1) para convertir un Int a Double antes de multiplicarlo por el precio. Investigue que Swift no convierte tipos automaticamente como otros lenguajes, obliga a hacer la conversion explicita para evitar errores silenciosos.

## Ejercicio 7 — Juego de adivinanza

### Prompt (estructura CTRFE):

CONTEXTO: Continuo en el mismo Playground de Swift. Ya trabaje condicionales, switch, for-in, while y repeat-while.

TAREA: Generar un mini juego de adivinanza con un numero secreto fijo de 42, cinco intentos simulados con variables individuales, un bucle while que recorra esos intentos, mensajes de "Muy alto", "Muy bajo" o "¡Correcto!" segun la comparacion, un contador de intentos usados, y un mensaje final que revele el numero si no se adivino en cinco intentos.

RESTRICCIONES: No usar arrays porque corresponden a la semana 3. Simular los intentos con variables sueltas. Comentar cada linea explicando la logica de comparacion.

FORMATO: Codigo Swift comentado linea por linea, listo para pegar al final del archivo.

EJEMPLO: La comparacion esperada era del tipo: if intento > secreto { print("Muy alto") } else if intento < secreto { print("Muy bajo") } else { print("¡Correcto!") }

### ¿Funcionó a la primera?
Si. Verifique que el bucle terminara correctamente cuando el jugador acierta, usando una bandera booleana en la condicion del while.

### ¿La IA usó algo que no conocías?
Si. La condicion compuesta while numeroDeIntento <= 5 && !adivino. Investigue que el operador ! invierte un valor booleano, asi que la condicion se lee como "mientras queden intentos Y todavia no haya adivinado".