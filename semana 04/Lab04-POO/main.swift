// Laboratorio 04 - Poo
// Docente: Juan Leon 
// Alumno: Junior Cueva fabian

import Foundation


// ===== CASO 1.5: HERENCIA Y POLIMORFISMO - LA CADENA DE SUCURSALES =====

enum CategoriaElectro {
    case lineaBlanca, tecnologia, pequenos
}

struct Electrodomestico {
    let nombre: String
    let marca: String
    let precioLista: Double
    let categoria: CategoriaElectro
}

// --- Ejemplo (ya resuelto): la base define el FLUJO; las hijas cambian las REGLAS ---
class Sucursal {
    let nombre: String
    let ciudad: String

    init(nombre: String, ciudad: String) {
        self.nombre = nombre
        self.ciudad = ciudad
    }

    func descuento() -> Double {
        return 0.05
    }

    func costoEnvio(monto: Double) -> Double {
        return 30.0
    }

    // REGLA 2: este metodo NO se sobreescribe en las subclases
    func cotizar(item: Electrodomestico) {
        let precioConDescuento = item.precioLista * (1 - descuento())
        let envio = costoEnvio(monto: precioConDescuento)
        let total = precioConDescuento + envio
        print("\(nombre): \(item.nombre) -> S/ \(precioConDescuento) + envio S/ \(envio) = S/ \(total)")
    }
}

// --- TODO 14: SucursalLima ---
class SucursalLima: Sucursal {
    override func descuento() -> Double {
        return 0.10
    }

    override func costoEnvio(monto: Double) -> Double {
        if monto >= 1500 {
            return 0.0
        }
        return 30.0
    }
}

// --- TODO 15: SucursalProvincia ---
// NO sobreescribe descuento(): hereda el 5% de la clase base
class SucursalProvincia: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        let calculado = monto * 0.08
        if calculado < 50.0 {
            return 50.0
        }
        return calculado
    }
}

// --- TODO 16: SucursalOutlet ---
class SucursalOutlet: Sucursal {
    override func descuento() -> Double {
        return 0.25
    }

    override func costoEnvio(monto: Double) -> Double {
        return 0.0
    }
}

// --- TODO 18: La prueba del polimorfismo (REGLA 6) ---
// Se agrega sin tocar cotizar() ni los for-in
class SucursalOnline: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        return 15.0
    }
}
// RESPUESTA TODO 18: se necesitaron 5 lineas nuevas para la clase
// mas 1 linea para sumarla al array, en total 6.
// No se modifico cotizar() ni ninguno de los dos for-in.
// Eso demuestra el polimorfismo: el codigo existente funciona con la
// clase nueva sin cambiar una sola linea.

// --- TODO 17: El recorrido polimorfico (REGLA 4) ---
let refrigeradora = Electrodomestico(nombre: "Refrigeradora", marca: "Frost",
                                     precioLista: 2000.0, categoria: .lineaBlanca)
let licuadora = Electrodomestico(nombre: "Licuadora", marca: "Mix",
                                 precioLista: 250.0, categoria: .pequenos)

let sucursales: [Sucursal] = [SucursalLima(nombre: "Lima Centro", ciudad: "Lima"),
                              SucursalProvincia(nombre: "Provincia Cusco", ciudad: "Cusco"),
                              SucursalOutlet(nombre: "Outlet Ate", ciudad: "Lima"),
                              SucursalOnline(nombre: "Tienda Online", ciudad: "Lima")]

print("===== Refrigeradora (S/ 2000.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: refrigeradora)
}

print("===== Licuadora (S/ 250.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: licuadora)
}

// ===== FIX: Este codigo tiene 2 errores =====

// FIX 7: faltaba la palabra clave override.
// Swift la exige para dejar explicito que se reemplaza un metodo heredado.
// Sin ella el compilador asume que intentas crear un metodo nuevo con el
// mismo nombre, lo cual seria un choque. Obligarla evita sobreescribir por accidente.
class SucursalMall: Sucursal {
    override func descuento() -> Double {
        return 0.12
    }
}

// FIX 8: faltaba la llamada a super.init al final del init.
// Una subclase debe inicializar primero sus propias propiedades y luego
// delegar en el init del padre para que nombre y ciudad queden asignados.
class SucursalExpress: Sucursal {
    let radioKm: Int

    init(nombre: String, ciudad: String, radioKm: Int) {
        self.radioKm = radioKm
        super.init(nombre: nombre, ciudad: ciudad)
    }
}

// ===== PREDICT: Que imprime? =====
let misteriosa: Sucursal = SucursalLima(nombre: "Lima Centro", ciudad: "Lima")
print(misteriosa.descuento())
// PREDICT 6: 0.1
// Justificacion: aunque la VARIABLE se declara de tipo Sucursal, el OBJETO
// que guarda es un SucursalLima. Swift usa despacho dinamico: decide que
// version del metodo ejecutar segun la clase real del objeto en tiempo de
// ejecucion, no segun el tipo declarado de la variable.

let monto = 2000.0 * (1 - misteriosa.descuento())
print(misteriosa.costoEnvio(monto: monto))
// PREDICT 7: 0.0
// monto = 2000 * (1 - 0.1) = 1800. Se ejecuta el costoEnvio de SucursalLima,
// y como 1800 es mayor o igual a 1500, el envio es gratis.