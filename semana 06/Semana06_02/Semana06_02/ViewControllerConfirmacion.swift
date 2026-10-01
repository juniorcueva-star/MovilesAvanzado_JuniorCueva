//
//  ViewControllerConfirmacion.swift
//  Semana06_02
//
//  Created by Junior Cueva on 1/10/26.
//

import UIKit

class ViewControllerConfirmacion: UIViewController {
    // instanciar la clase ClienteModel
    var pCliente: ClienteModel = ClienteModel()
    // definir los controles
    @IBOutlet weak var tfApellido: UILabel!
    @IBOutlet weak var tfNombre: UILabel!
    @IBOutlet weak var tfDni: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnVolver(_ sender: Any) {
    }
}
