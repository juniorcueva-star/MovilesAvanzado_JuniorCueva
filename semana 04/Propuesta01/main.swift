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