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