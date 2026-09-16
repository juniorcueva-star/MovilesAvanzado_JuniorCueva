# Prompts utilizados — Laboratorio 04

## Herramienta de IA utilizada
Claude

## Caso 2B — Biblioteca

### Prompt 1:

CONTEXTO: Soy estudiante de Swift, cuarta semana del curso Programacion en Moviles Avanzado. Trabajo en un archivo main.swift que compilo con swiftc. Ya vi condicionales, bucles, funciones, colecciones, structs, clases, herencia, protocolos y enums.

TAREA: Necesito una biblioteca que gestione libros y prestamos. Debe tener un enum EstadoLibro con los casos disponible y prestado; un struct Libro con titulo (String), autor (String) y estado (EstadoLibro, que empieza en .disponible); y una class Biblioteca con la propiedad var libros: [Libro] que empieza vacia y los metodos agregar(libro:), prestar(titulo:) -> Bool, devolver(titulo:) -> Bool e inventario(). El metodo prestar busca el libro por titulo, y si existe y esta disponible lo marca como prestado, imprime la aprobacion y devuelve true; si ya esta prestado o no existe, imprime el error correspondiente y devuelve false. El metodo devolver tiene la logica inversa. El metodo inventario imprime cada libro con su autor y su estado.

RESTRICCIONES: Solo struct, class, herencia, protocolos, enums, arrays, bucles y funciones. Sin optionals ni guard let, sin firstIndex(where:), sin didSet, sin propiedades calculadas, sin genericos.

FORMATO: Solo el codigo Swift, con las firmas exactas que te indico, y un comentario en cada linea explicando que hace.

EJEMPLO: La salida en consola debe ser:
Prestamo aprobado: Swift desde cero
Error: Swift desde cero ya esta prestado
Devolucion registrada: Swift desde cero
Prestamo aprobado: El metro de Lima
Error: no existe Programacion en Kotlin
===== INVENTARIO =====
Las aventuras de Junior (Junior Cueva) - disponible
Swift desde cero (Junior Cueva) - disponible
El metro de Lima (Junior Cueva) - prestado

### Respuesta de la IA:

Entrego el codigo completo con el enum, el struct y la clase. La diferencia principal fue que agrego un metodo auxiliar llamado posicionDe(titulo:) que devuelve el indice del libro buscado, y que prestar y devolver reutilizan. Tambien puso el switch dentro del propio enum como un metodo texto(), en lugar de escribirlo dentro de inventario().

### ¿Funcionó a la primera?

Si. El codigo compilo sin errores y la salida coincidio exactamente con la de mi Parte A.

### ¿Usó algo que no hemos visto en clase?

No. Respeto todas las restricciones. Note que para indicar que un libro no existe uso un return -1 en lugar de un Optional, que era justamente lo que habia prohibido en el prompt. Un indice nunca puede ser negativo, asi que -1 funciona como marca de no encontrado sin necesidad de optionals.

## Mi versión (Parte A) vs. la versión de la IA (Parte B)

### ¿Qué hizo distinto la IA respecto a mi solución?

Cuatro cosas:

1. Creo un metodo auxiliar posicionDe(titulo:) que busca el indice una sola vez. En mi version repeti el bucle de busqueda dentro de prestar y dentro de devolver, o sea el mismo codigo dos veces.

2. Puso el switch dentro del enum EstadoLibro como un metodo texto(). En mi version el switch estaba dentro de inventario().

3. Le dio al struct Libro un metodo descripcion() que arma su propia linea de texto. En mi version era inventario() quien armaba la cadena.

4. En inventario() uso for libro in libros en lugar de for i in 0..<libros.count, porque ahi solo se lee y no hace falta el indice.

### ¿Hay alguna línea de la IA que no entiendo del todo? ¿Cuál?

La linea `switch self` dentro del enum. Tuve que investigar que self dentro de un enum se refiere al caso concreto sobre el que se llamo el metodo, no a una instancia como en las clases. Es decir, si llamo `.prestado.texto()`, dentro del switch self vale .prestado.

### ¿Qué me pareció mejor de MI versión?

Que es mas directa y facil de seguir. Cada metodo tiene toda su logica adentro, sin saltar a otro metodo para entender que hace. Para alguien que recien aprende, leer prestar() de arriba a abajo y entenderlo completo es una ventaja.

Tambien que respete la pista del enunciado al pie de la letra: recorrer por indice con for i in 0..<libros.count, que es lo que el profesor pidio explicitamente.

### ¿Qué me pareció mejor de la versión de la IA?

Que no repite codigo. Al tener el metodo posicionDe(titulo:), si mañana necesito buscar un libro para otra cosa, ya tengo la busqueda lista. En mi version tendria que copiar el bucle una tercera vez.

Tambien que reparte mejor las responsabilidades: el enum sabe como describirse, el libro sabe como mostrarse, y la biblioteca solo gestiona prestamos. En mi version la clase Biblioteca hacia todo.