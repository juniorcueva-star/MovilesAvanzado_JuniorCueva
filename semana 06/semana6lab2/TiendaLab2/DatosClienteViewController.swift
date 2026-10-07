// Desarrollado por: Junior Cueva
import UIKit
class DatosClienteViewController: UIViewController {
    var carrito: CarritoModel!
    @IBOutlet weak var apellidosField: UITextField!
    @IBOutlet weak var nombresField: UITextField!
    @IBOutlet weak var dniField: UITextField!
    @IBAction func validarTapped(_ sender: UIButton) {
        let apellidos = (apellidosField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let nombres = (nombresField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let dni = (dniField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        var mensaje = "Datos válidos. La confirmación de compra y la boleta se implementarán en el siguiente avance."
        var titulo = "Datos del cliente"
        if apellidos.isEmpty || nombres.isEmpty || dni.isEmpty {
            titulo = "Campos obligatorios"
            mensaje = "Completa apellidos, nombres y DNI."
        } else if dni.count != 8 || !dni.allSatisfy({ "0123456789".contains($0) }) {
            titulo = "DNI inválido"
            mensaje = "El DNI debe tener exactamente 8 dígitos."
        }
        view.endEditing(true)
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
