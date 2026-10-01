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

    // controles de salida
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var lblIgv: UILabel!
    @IBOutlet weak var lblBase: UILabel!
    @IBOutlet weak var lblIntereses: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblCuota: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
