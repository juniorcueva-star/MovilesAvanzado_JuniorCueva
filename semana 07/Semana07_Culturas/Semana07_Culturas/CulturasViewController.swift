import UIKit

final class CulturasViewController: UIViewController {
    private let culturas = Cultura.ejemplos
    private let tabla = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Culturas peruanas"
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        tabla.translatesAutoresizingMaskIntoConstraints = false
        tabla.backgroundColor = .clear
        tabla.separatorStyle = .none
        tabla.rowHeight = UITableView.automaticDimension
        tabla.estimatedRowHeight = 124
        tabla.dataSource = self
        tabla.register(CulturaTableViewCell.self, forCellReuseIdentifier: CulturaTableViewCell.reuseIdentifier)
        view.addSubview(tabla)

        NSLayoutConstraint.activate([
            tabla.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabla.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabla.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabla.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
