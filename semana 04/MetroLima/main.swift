// Desarrollado por: Junior Cueva
// Docente: Juan Leon - Tecsup


import Foundation

// estacion
class Estacion {
    var nombre: String
    var codigo: String
    var linea: String
    var orden: Int
    var operativa: Bool
    var ascensor: String
    var repetida: Bool

    init(nombre: String, codigo: String, linea: String, orden: Int, operativa: Bool, ascensor: String) {
        self.nombre = nombre
        self.codigo = codigo
        self.linea = linea
        self.orden = orden
        self.operativa = operativa
        self.ascensor = ascensor
        self.repetida = false
    }

    func numeroLinea() -> String {
        if linea == "Linea 1" {
            return "1"
        }
        if linea == "Linea 2" {
            return "2"
        }
        if linea == "Linea 3" {
            return "3"
        }
        return "4"
    }

    func nombreCompleto() -> String {
        if repetida {
            return "\(nombre) \(numeroLinea())"
        }
        return nombre
    }

    func marca() -> String {
        if operativa {
            return "(F)"
        }
        return "(NF)"
    }

    func etiqueta() -> String {
        if codigo == "" {
            return "\(orden). \(nombreCompleto()) \(marca())"
        }
        return "\(codigo)  \(nombreCompleto()) \(marca())"
    }

    func etiquetaConLinea() -> String {
        return "\(linea) - \(nombre) \(marca())"
    }
}

// ===== CLASE LINEA =====
class Linea {
    var nombre: String
    var color: String
    var estaciones: [Estacion]

    init(nombre: String, color: String) {
        self.nombre = nombre
        self.color = color
        self.estaciones = []
    }

    func agregar(_ e: Estacion) {
        estaciones.append(e)
    }

    func mostrar() {
        print("")
        print("--- \(nombre)  (color \(color)) ---")
        for e in estaciones {
            print("  " + e.etiqueta())
        }
        print("  Total: \(estaciones.count) estaciones")
    }
}

// CONEXION 
class Conexion {
    var lineaA: String
    var estacionA: String
    var lineaB: String
    var estacionB: String
    var tipo: String
    var ubicacion: String

    init(lineaA: String, estacionA: String, lineaB: String, estacionB: String, tipo: String, ubicacion: String) {
        self.lineaA = lineaA
        self.estacionA = estacionA
        self.lineaB = lineaB
        self.estacionB = estacionB
        self.tipo = tipo
        self.ubicacion = ubicacion
    }

    func conecta(nombre: String, linea: String) -> Bool {
        if estacionA == nombre && lineaA == linea {
            return true
        }
        if estacionB == nombre && lineaB == linea {
            return true
        }
        return false
    }

    func destino(nombre: String, linea: String) -> String {
        if estacionA == nombre && lineaA == linea {
            return "\(lineaB), en la estacion \(estacionB)"
        }
        return "\(lineaA), en la estacion \(estacionA)"
    }

    func mostrar() {
        print("  \(lineaA) (\(estacionA))  <-->  \(lineaB) (\(estacionB))")
        print("     Tipo: \(tipo)")
        print("     Ubicacion: \(ubicacion)")
    }
}