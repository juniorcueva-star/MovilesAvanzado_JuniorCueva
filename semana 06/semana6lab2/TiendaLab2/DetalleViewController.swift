// Desarrollado por: Junior Cueva
import UIKit

class DetalleViewController: UIViewController {
    var carrito: CarritoModel!
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

    @IBAction func agregarTapped(_ sender: UIButton) {
        if let producto = producto {
            if carrito.agregar(producto: producto, cantidad: Int(cantidadStepper.value)) {
                navigationController?.popViewController(animated: true)
            } else {
                let alerta = UIAlertController(title: "Stock insuficiente", message: "La cantidad solicitada, sumada a lo que ya tienes en el carrito, supera el stock disponible.", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
                present(alerta, animated: true)
            }
        }
    }
    @IBAction func cantidadChanged(_ sender: UIStepper) {
        cantidadLabel.text = "Cantidad: \(Int(sender.value))"
    }
}
