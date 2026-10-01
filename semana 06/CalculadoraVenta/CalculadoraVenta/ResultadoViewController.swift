//
//  ResultadoViewController.swift
//  CalculadoraVenta
//
//  Created by Junior Cueva on 1/10/26.
//

import UIKit

class ResultadoViewController: UIViewController {
    // instanciar la clase VentaModel
    var pVenta: VentaModel = VentaModel()
    // textos de cabecera que llegan desde la pantalla Nueva Venta
    var pElectrodomestico: String = ""
    var pDetalle: String = ""

    // cabecera
    @IBOutlet weak var lblProducto: UILabel!
    @IBOutlet weak var lblDetalle: UILabel!

    // controles de salida (uno por cada valor calculado)
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var lblIgv: UILabel!
    @IBOutlet weak var lblBase: UILabel!
    @IBOutlet weak var lblIntereses: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblCuota: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // cabecera con el nombre del electrodomestico y el detalle de la venta
        if pElectrodomestico == "" {
            self.lblProducto.text = "Electrodoméstico"
        } else {
            self.lblProducto.text = pElectrodomestico
        }
        self.lblDetalle.text = pDetalle

        // mostrar cada valor formateado en soles
        self.lblSubtotal.text = String(format: "S/. %.2f", pVenta.subtotal)
        self.lblIgv.text = String(format: "S/. %.2f", pVenta.igv)
        self.lblBase.text = String(format: "S/. %.2f", pVenta.base)
        self.lblIntereses.text = String(format: "S/. %.2f", pVenta.intereses)
        self.lblTotal.text = String(format: "S/. %.2f", pVenta.total)
        self.lblCuota.text = String(format: "S/. %.2f", pVenta.cuota)
    }
}
