//
//  VentaModel.swift
//  CalculadoraVenta
//
//  Created by Junior Cueva on 1/10/26.
//

import UIKit

// Por que class y no struct:
// VentaModel se crea en la pantalla "Nueva Venta" y se entrega a la pantalla
// "Resultado" en prepare(for:sender:). Al ser class es un tipo por referencia:
// las dos pantallas apuntan al mismo objeto (no se copia) y ademas puede heredar
// de NSObject, igual que ClienteModel en el Ejercicio 2. Un struct no puede
// heredar de NSObject y se copiaria en cada asignacion.
class VentaModel: NSObject {
    var subtotal: Double = 0
    var igv: Double = 0
    var base: Double = 0
    var intereses: Double = 0
    var total: Double = 0
    var cuota: Double = 0

    // inicializador sin parametros y con parametros
    override init() {
        self.subtotal = 0
        self.igv = 0
        self.base = 0
        self.intereses = 0
        self.total = 0
        self.cuota = 0
    }

    init(pSubtotal: Double, pIgv: Double, pBase: Double, pIntereses: Double, pTotal: Double, pCuota: Double) {
        self.subtotal = pSubtotal
        self.igv = pIgv
        self.base = pBase
        self.intereses = pIntereses
        self.total = pTotal
        self.cuota = pCuota
    }
}
