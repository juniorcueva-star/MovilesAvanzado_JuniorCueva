import Foundation

// tipo de alumno 
enum TipoAlumno {
    case tecsup
    case externo

    func texto() -> String {
        switch self {
        case .tecsup: return "Si"
        case .externo: return "No"
        }
    }
}

// un curso inscrito 
struct Curso {
    let nombre: String
    let precioUnitario: Double
    let cantidad: Int

    func importe() -> Double {
        return precioUnitario * Double(cantidad)
    }
}

// estudiante y sus cursos 
class Estudiante {
    let nombre: String
    let dni: String
    let tipo: TipoAlumno
    var cursos: [Curso] = []

    init(nombre: String, dni: String, tipo: TipoAlumno) {
        self.nombre = nombre
        self.dni = dni
        self.tipo = tipo
    }

    func inscribir(curso: Curso) {
        cursos.append(curso)
    }

    func totalCursos() -> Int {
        var total = 0
        for curso in cursos {
            total += curso.cantidad
        }
        
        return total
    }
        func subtotal() -> Double {
        var suma = 0.0
        for curso in cursos {
            suma += curso.importe()
        }
        return suma
    }

    func igv() -> Double {
        return subtotal() * 0.18
    }

    func totalConIgv() -> Double {
        return subtotal() + igv()
    }

        func aplicaDescuento() -> Bool {
        return totalCursos() >= 3
    }

    func descuentoPorCantidad() -> Double {
        if aplicaDescuento() {
            return totalConIgv() * 0.10
        }
        return 0.0
    }

    func descuentoTecsup() -> Double {
        if aplicaDescuento() && tipo == .tecsup {
            return 400.0
        }
        return 0.0
    }

    func totalFinal() -> Double {
        return totalConIgv() - descuentoPorCantidad() - descuentoTecsup()
    }
}

