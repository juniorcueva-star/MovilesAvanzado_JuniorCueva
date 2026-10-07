// Desarrollado por: Junior Cueva
import UIKit

class DetalleViewController: UIViewController {
    var producto: Producto?
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var cantidadLabel: UILabel!
    @IBOutlet weak var cantidadStepper: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let producto = producto {
            nombreLabel.text = producto.nombre
            precioLabel.text = String(format: "Precio: S/ %.2f", producto.precio)
            stockLabel.text = "Stock disponible: \(producto.stock)"
            cantidadStepper.maximumValue = Double(producto.stock)
        }
    }

    @IBAction func cantidadChanged(_ sender: UIStepper) {
        cantidadLabel.text = "Cantidad: \(Int(sender.value))"
    }
}
