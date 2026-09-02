# Prompts — Lab 03

## Docente: Juan Leon — Tecsup
## Desarrollado por: Junior Cueva
## Herramienta: Claude

## Ejercicio 6 — Gestión de notas

### Prompt (CTRFE):

CONTEXTO: Estudiante iOS semana 3. Ya vi variables, condicionales, switch, bucles for-in, while, repeat-while, y esta semana Arrays, Diccionarios y Sets. Trabajo en un Playground con import Foundation y leo datos con readLine().

TAREA: Crear un sistema de gestion de notas que pida N alumnos con su nombre y 3 notas cada uno, guardados en un diccionario [String: [Double]]. Calcular el promedio de cada alumno y clasificarlo con switch en Excelente, Bueno, Aprobado o Desaprobado. Mostrar estadisticas generales: promedio de todos, nota mas alta con su alumno, nota mas baja con su alumno y porcentaje de aprobados.

RESTRICCIONES: Solo temas de semana 1 a 3. NO usar struct, class, funciones ni closures como map o filter. Solo bucles y condicionales.

FORMATO: Codigo con comentario en CADA linea explicando especificamente que hace.

EJEMPLO: El diccionario debe verse asi: registroNotas["Ana"] = [18.0, 19.0, 17.0]

### ¿Funcionó a la primera?

Si. Lo probe con 2 alumnos: Ana con notas 18, 19 y 17 salio Excelente, y Luis con 12, 11 y 10 salio Desaprobado, con 50% de aprobados.

### ¿La IA usó algo que no conocías?

Si. El diccionario de tipo [String: [Double]], donde el valor es un array completo en lugar de un solo dato. Tambien el uso de un bucle for anidado dentro de otro para pedir las 3 notas de cada alumno.

## Ejercicio 7 — Inventario con menú

### Prompt (CTRFE):

CONTEXTO: Mismo Playground de Swift, semana 3. Ya tengo un ejercicio con diccionarios funcionando.

TAREA: Crear un inventario que pida N productos con nombre, precio y stock guardados en dos diccionarios paralelos. Luego mostrar un menu repetitivo con while que tenga 5 opciones: ver inventario, buscar producto, mostrar stock bajo menor a 5, calcular valor total del inventario y salir.

RESTRICCIONES: Solo semana 1 a 3. Sin struct, class ni funciones. El menu debe repetirse hasta que el usuario elija salir.

FORMATO: Codigo comentado linea por linea, listo para pegar al final del archivo.

EJEMPLO: El menu debe repetirse asi: while !salir { ... case 5: salir = true }

### ¿Funcionó a la primera?

Si. El menu se repite correctamente y solo termina cuando se elige la opcion 5.

### ¿La IA usó algo que no conocías?

Si. El uso de dos diccionarios paralelos que comparten la misma clave, uno para precios y otro para stocks. Para acceder al stock de un producto se usa if let stock = inventarioStocks[nombre], que es una busqueda segura con Optional.

## En que ayudó la IA

Estructurar el menu con una bandera booleana en la condicion del while, y combinar dos diccionarios usando la misma clave para relacionar precio y stock de cada producto.
