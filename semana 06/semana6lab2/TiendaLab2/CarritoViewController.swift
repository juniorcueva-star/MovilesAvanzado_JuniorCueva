// Desarrollado por: Junior Cueva
import UIKit
class CarritoViewController: UIViewController {
    var carrito: CarritoModel!
    @IBOutlet weak var resumenLabel: UILabel!
    @IBOutlet weak var continuarButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        continuarButton.isEnabled = !carrito.items.isEmpty
        var texto = carrito.items.isEmpty ? "Tu carrito está vacío.\n" : ""
        for item in carrito.items {
            texto += String(format: "%@ x%d — S/ %.2f\n", item.producto.nombre, item.cantidad, item.subtotal())
        }
        texto += String(format: "\nSubtotal: S/ %.2f\nDescuento (%.0f%%): -S/ %.2f\nIGV (18%%): S/ %.2f\nTOTAL: S/ %.2f\n", carrito.subtotal(), carrito.porcentajeDescuento() * 100, carrito.descuento(), carrito.igv(), carrito.total())
        texto += "\nCategoría: \(carrito.categoria())"
        resumenLabel.text = texto
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irDatosCliente", let destino = segue.destination as? DatosClienteViewController {
            destino.carrito = carrito
        }
    }
}
