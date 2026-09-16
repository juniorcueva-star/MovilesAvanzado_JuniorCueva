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

        func mostrarFactura() {
        let separador = String(repeating: "-", count: 40)

        print("")
        print("FACTURA DE CURSOS")
        print("Estudiante: \(nombre)")
        print("DNI: \(dni)")
        print("Alumno de Tecsup: \(tipo.texto())")
        print(separador)

        for curso in cursos {
            print("\(curso.nombre) x\(curso.cantidad) - S/ \(String(format: "%.2f", curso.importe()))")
        }

        print(separador)
        print("Subtotal: S/ \(String(format: "%.2f", subtotal()))")
        print("IGV (18%): S/ \(String(format: "%.2f", igv()))")
        print("Total con IGV: S/ \(String(format: "%.2f", totalConIgv()))")

        if descuentoPorCantidad() > 0 {
            print("Descuento 10% por cantidad: -S/ \(String(format: "%.2f", descuentoPorCantidad()))")
        }
        if descuentoTecsup() > 0 {
            print("Descuento especial Tecsup: -S/ \(String(format: "%.2f", descuentoTecsup()))")
        }

        print(separador)
        print("TOTAL FINAL A PAGAR: S/ \(String(format: "%.2f", totalFinal()))")
    }
}


let alumno = Estudiante(nombre: "Junior Cueva", dni: "78965412", tipo: .tecsup)
alumno.inscribir(curso: Curso(nombre: "Swift Avanzado", precioUnitario: 450.0, cantidad: 1))
alumno.inscribir(curso: Curso(nombre: "IA con Python", precioUnitario: 650.0, cantidad: 2))
alumno.inscribir(curso: Curso(nombre: "Diseno UX/UI", precioUnitario: 500.0, cantidad: 1))
alumno.mostrarFactura()
