// ===== CASO 2 - PARTE B: BIBLIOTECA (CON IA) =====
// Docente: Juan Leon Suiyon - Tecsup
// Alumno: Junior Cueva

import Foundation                                        // Trae la biblioteca base de Swift

enum EstadoLibro {                                        // Enum: tipo con un conjunto cerrado de valores
    case disponible                                       // El libro esta en estanteria
    case prestado                                         // El libro esta fuera de la biblioteca

    func texto() -> String {                              // Metodo dentro del enum: cada caso sabe describirse
        switch self {                                     // self es el caso concreto sobre el que se llamo
        case .disponible: return "disponible"             // Devuelve el texto del primer caso
        case .prestado: return "prestado"                 // Devuelve el texto del segundo caso
        }                                                 // Sin default: Swift sabe que solo hay dos casos
    }
}

struct Libro {                                            // Struct: tipo por VALOR, se copia al asignarse
    let titulo: String                                    // let porque el titulo nunca cambia
    let autor: String                                     // let porque el autor nunca cambia
    var estado: EstadoLibro = .disponible                 // var porque si cambia; nace disponible por defecto

    func descripcion() -> String {                        // El propio libro arma su linea de inventario
        return "\(titulo) (\(autor)) - \(estado.texto())" // Delega el texto del estado al enum
    }
}

class Biblioteca {                                        // Class: tipo por REFERENCIA, hay una sola instancia
    var libros: [Libro] = []                              // Array de structs Libro, arranca vacio

    func agregar(libro: Libro) {                          // Recibe una COPIA del struct
        libros.append(libro)                              // La copia queda guardada dentro del array
    }

    func posicionDe(titulo: String) -> Int {              // Metodo auxiliar: busca el indice de un titulo
        for i in 0..<libros.count {                       // Recorre por indice, no por elemento
            if libros[i].titulo == titulo {               // Compara el titulo de cada posicion
                return i                                  // Devuelve la posicion encontrada y corta el bucle
            }
        }
        return -1                                         // -1 significa no encontrado, evita usar Optional
    }

    func prestar(titulo: String) -> Bool {                // Devuelve true si el prestamo se concreto
        let i = posicionDe(titulo: titulo)                // Obtiene la posicion una sola vez
        if i == -1 {                                      // El titulo no esta en el array
            print("Error: no existe \(titulo)")           // Informa que el libro no existe
            return false                                  // Corta el metodo devolviendo fracaso
        }
        if libros[i].estado == .prestado {                // El libro existe pero ya salio
            print("Error: \(titulo) ya esta prestado")    // Informa el conflicto
            return false                                  // Corta el metodo devolviendo fracaso
        }
        libros[i].estado = .prestado                      // Modifica el struct DENTRO del array; una copia no serviria
        print("Prestamo aprobado: \(titulo)")             // Confirma la operacion
        return true                                       // Devuelve exito
    }

    func devolver(titulo: String) -> Bool {               // Logica inversa a prestar
        let i = posicionDe(titulo: titulo)                // Reutiliza el mismo metodo auxiliar
        if i == -1 {                                      // El titulo no pertenece a esta biblioteca
            print("Error: no existe \(titulo)")           // Informa que el libro no existe
            return false                                  // Corta el metodo devolviendo fracaso
        }
        if libros[i].estado == .disponible {              // Nadie lo tenia prestado
            print("Error: \(titulo) no esta prestado")    // Informa que la devolucion no aplica
            return false                                  // Corta el metodo devolviendo fracaso
        }
        libros[i].estado = .disponible                    // Devuelve el libro a estanteria dentro del array
        print("Devolucion registrada: \(titulo)")         // Confirma la operacion
        return true                                       // Devuelve exito
    }

    func inventario() {                                   // Imprime el estado completo de la coleccion
        print("===== INVENTARIO =====")                   // Encabezado del reporte
        for libro in libros {                             // Recorre por elemento: aqui solo se lee, no se modifica
            print(libro.descripcion())                    // Cada libro arma su propia linea
        }
    }
}

// --- Simulacion ---
let biblioteca = Biblioteca()                             // Crea la unica instancia de la biblioteca

biblioteca.agregar(libro: Libro(titulo: "Las aventuras de Junior", autor: "Junior Cueva"))
biblioteca.agregar(libro: Libro(titulo: "Swift desde cero", autor: "Junior Cueva"))
biblioteca.agregar(libro: Libro(titulo: "El metro de Lima", autor: "Junior Cueva"))

_ = biblioteca.prestar(titulo: "Swift desde cero")        // Caso exitoso: existe y esta disponible
_ = biblioteca.prestar(titulo: "Swift desde cero")        // Caso conflicto: existe pero ya esta prestado
_ = biblioteca.devolver(titulo: "Swift desde cero")       // Caso exitoso: regresa a estanteria
_ = biblioteca.prestar(titulo: "El metro de Lima")        // Otro prestamo exitoso
_ = biblioteca.prestar(titulo: "Programacion en Kotlin")  // Caso inexistente: no esta en el array

biblioteca.inventario()                                   // Reporte final de los tres libros