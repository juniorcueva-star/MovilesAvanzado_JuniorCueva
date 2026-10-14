import UIKit

final class CulturasViewController: UIViewController {
    private let culturas = Cultura.ejemplos
    @IBOutlet private weak var tabla: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Culturas peruanas"
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        tabla.backgroundColor = .clear
        tabla.separatorStyle = .none
        tabla.rowHeight = UITableView.automaticDimension
        tabla.estimatedRowHeight = 124
        tabla.dataSource = self
        tabla.delegate = self
        tabla.register(CulturaTableViewCell.self, forCellReuseIdentifier: CulturaTableViewCell.reuseIdentifier)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "mostrarDetalle",
              let detalle = segue.destination as? DetalleCulturaViewController,
              let cultura = sender as? Cultura else { return }
        detalle.cultura = cultura
    }
}

extension CulturasViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "mostrarDetalle", sender: culturas[indexPath.row])
    }
}

extension CulturasViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CulturaTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! CulturaTableViewCell
        cell.configurar(con: culturas[indexPath.row])
        return cell
    }
}
