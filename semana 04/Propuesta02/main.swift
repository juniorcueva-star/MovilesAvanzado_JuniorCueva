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

// CLIENTE NATURAL 
class ClienteNatural: Cliente {
    let nombreCompleto: String
    let dni: String

    init(codigo: String, direccion: String, fechaDeRegistro: String,
         numeroCuenta: String, montoMinimoApertura: Double,
         nombreCompleto: String, dni: String) {
        self.nombreCompleto = nombreCompleto
        self.dni = dni
        super.init(codigo: codigo, direccion: direccion,
                   fechaDeRegistro: fechaDeRegistro,
                   numeroCuenta: numeroCuenta,
                   montoMinimoApertura: montoMinimoApertura)
    }

    override func mostrarDatos() {
        print("Cliente Natural:")
        print("Nombre: \(nombreCompleto)")
        print("DNI: \(dni)")
        super.mostrarDatos()
    }
}

// CLIENTE JURIDICO 
class ClienteJuridico: Cliente {
    let razonSocial: String
    let ruc: String
    let representanteLegal: String

    init(codigo: String, direccion: String, fechaDeRegistro: String,
         numeroCuenta: String, montoMinimoApertura: Double,
         razonSocial: String, ruc: String, representanteLegal: String) {
        self.razonSocial = razonSocial
        self.ruc = ruc
        self.representanteLegal = representanteLegal
        super.init(codigo: codigo, direccion: direccion,
                   fechaDeRegistro: fechaDeRegistro,
                   numeroCuenta: numeroCuenta,
                   montoMinimoApertura: montoMinimoApertura)
    }

    override func mostrarDatos() {
        print("Cliente Juridico:")
        print("Razon Social: \(razonSocial)")
        print("RUC: \(ruc)")
        print("Representante Legal: \(representanteLegal)")
        super.mostrarDatos()
    }
}


let cliente1 = ClienteNatural(codigo: "C001",
                              direccion: "Av. Lima 123",
                              fechaDeRegistro: "2025-04-03",
                              numeroCuenta: "001-2025-000123",
                              montoMinimoApertura: 500.0,
                              nombreCompleto: "Juan Perez",
                              dni: "12345678")

let cliente2 = ClienteJuridico(codigo: "C002",
                               direccion: "Jr. Empresas 456",
                               fechaDeRegistro: "2025-04-01",
                               numeroCuenta: "001-2025-000456",
                               montoMinimoApertura: 3000.0,
                               razonSocial: "Soluciones SAC",
                               ruc: "20123456789",
                               representanteLegal: "Maria Leon")

let clientes: [Cliente] = [cliente1, cliente2]

for cliente in clientes {
    cliente.mostrarDatos()
    print("------------------------")
}