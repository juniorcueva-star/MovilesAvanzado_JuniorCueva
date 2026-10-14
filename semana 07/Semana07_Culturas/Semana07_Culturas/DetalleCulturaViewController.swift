import UIKit

final class DetalleCulturaViewController: UIViewController {
    var cultura: Cultura!

    @IBOutlet private weak var foto: UIImageView!
    @IBOutlet private weak var nombre: UILabel!
    @IBOutlet private weak var region: UILabel!
    @IBOutlet private weak var descripcion: UILabel!
    @IBOutlet private weak var credito: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = cultura.nombre
        navigationItem.largeTitleDisplayMode = .never

        foto.image = UIImage(named: cultura.imagen)
        foto.contentMode = .scaleAspectFill
        foto.clipsToBounds = true
        foto.layer.cornerRadius = 16
        foto.accessibilityLabel = "Imagen representativa de la cultura \(cultura.nombre)"

        nombre.text = cultura.nombre
        region.text = cultura.region
        descripcion.text = cultura.descripcion
        credito.text = cultura.creditoImagen
    }

    @IBAction private func abrirFuente(_ sender: UIButton) {
        UIApplication.shared.open(cultura.urlImagen)
    }
}
