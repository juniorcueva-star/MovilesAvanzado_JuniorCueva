import Foundation

// CLIENTE
class Cliente {
    let codigo: String
    let direccion: String
    let fechaDeRegistro: String
    let numeroCuenta: String
    let montoMinimoApertura: Double

    init(codigo: String, direccion: String, fechaDeRegistro: String,
         numeroCuenta: String, montoMinimoApertura: Double) {
        self.codigo = codigo
        self.direccion = direccion
        self.fechaDeRegistro = fechaDeRegistro
        self.numeroCuenta = numeroCuenta
        self.montoMinimoApertura = montoMinimoApertura
    }

    func mostrarDatos() {
        print("Codigo: \(codigo)")
        print("Direccion: \(direccion)")
        print("Fecha de registro: \(fechaDeRegistro)")
        print("N Cuenta: \(numeroCuenta)")
        print("Monto minimo de apertura: S/ \(String(format: "%.2f", montoMinimoApertura))")
    }
}