//
//  NuevaVentaViewController.swift
//  CalculadoraVenta
//
//  Created by Junior Cueva on 1/10/26.
//

import UIKit

class NuevaVentaViewController: UIViewController {

    // controles de entrada
    @IBOutlet weak var tfElectrodomestico: UITextField!
    @IBOutlet weak var tfPrecio: UITextField!
    @IBOutlet weak var tfCantidad: UITextField!
    @IBOutlet weak var tfMeses: UITextField!
    @IBOutlet weak var tfInteres: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // convierte el texto de un campo a numero
    // si el campo esta vacio o no es un numero devuelve 0
    func leerNumero(_ campo: UITextField) -> Double {
        let texto: String = campo.text!.replacingOccurrences(of: ",", with: ".")
        return Double(texto) ?? 0
    }

    // realiza el calculo completo y arma un VentaModel con los resultados
    func calcularVenta() -> VentaModel {
        let precioUnitario: Double = leerNumero(self.tfPrecio)
        let cantidad: Double = leerNumero(self.tfCantidad)
        let meses: Double = leerNumero(self.tfMeses)
        let tasaInteresMensual: Double = leerNumero(self.tfInteres)

        let subtotal: Double = precioUnitario * cantidad
        let igv: Double = subtotal * 0.18
        let base: Double = subtotal + igv
        let intereses: Double = base * (tasaInteresMensual / 100) * meses
        let total: Double = base + intereses
        var cuota: Double = 0
        if meses > 0 {
            cuota = total / meses
        }

        let oVenta: VentaModel = VentaModel(pSubtotal: subtotal, pIgv: igv, pBase: base,
                                            pIntereses: intereses, pTotal: total, pCuota: cuota)
        return oVenta
    }

    // se ejecuta antes del segue Show: le pasamos el VentaModel a la pantalla Resultado
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultado" {
            let oResultado = segue.destination as! ResultadoViewController
            oResultado.pVenta = calcularVenta()
        }
    }
}
