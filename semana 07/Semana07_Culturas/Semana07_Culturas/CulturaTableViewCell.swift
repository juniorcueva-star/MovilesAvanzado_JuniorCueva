import UIKit

final class CulturaTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CulturaTableViewCell"

    private let tarjeta = UIView()
    private let foto = UIImageView()
    private let nombre = UILabel()
    private let region = UILabel()
    private let flecha = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurarVista()
    }

    required init?(coder: NSCoder) {
        fatalError("Esta celda se crea por código")
    }

    func configurar(con cultura: Cultura) {
        nombre.text = cultura.nombre
        region.text = cultura.region
        foto.image = UIImage(named: cultura.imagen)
        foto.accessibilityLabel = "Imagen representativa de \(cultura.nombre)"
        accessibilityLabel = "\(cultura.nombre), \(cultura.region)"
        accessibilityTraits = .button
    }

    private func configurarVista() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        tarjeta.translatesAutoresizingMaskIntoConstraints = false
        tarjeta.backgroundColor = .secondarySystemGroupedBackground
        tarjeta.layer.cornerRadius = 16
        tarjeta.layer.masksToBounds = true
        contentView.addSubview(tarjeta)

        foto.translatesAutoresizingMaskIntoConstraints = false
        foto.contentMode = .scaleAspectFill
        foto.clipsToBounds = true
        foto.layer.cornerRadius = 10

        nombre.font = .preferredFont(forTextStyle: .headline)
        nombre.adjustsFontForContentSizeCategory = true
        nombre.numberOfLines = 0

        region.font = .preferredFont(forTextStyle: .subheadline)
        region.adjustsFontForContentSizeCategory = true
        region.textColor = .secondaryLabel
        region.numberOfLines = 0

        let textos = UIStackView(arrangedSubviews: [nombre, region])
        textos.translatesAutoresizingMaskIntoConstraints = false
        textos.axis = .vertical
        textos.spacing = 5
        textos.alignment = .leading

        flecha.translatesAutoresizingMaskIntoConstraints = false
        flecha.tintColor = .tertiaryLabel
        flecha.contentMode = .scaleAspectFit

        tarjeta.addSubview(foto)
        tarjeta.addSubview(textos)
        tarjeta.addSubview(flecha)

        NSLayoutConstraint.activate([
            tarjeta.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            tarjeta.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tarjeta.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tarjeta.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            foto.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 12),
            foto.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 12),
            foto.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -12),
            foto.widthAnchor.constraint(equalToConstant: 88),
            foto.heightAnchor.constraint(equalToConstant: 88),

            textos.leadingAnchor.constraint(equalTo: foto.trailingAnchor, constant: 14),
            textos.centerYAnchor.constraint(equalTo: tarjeta.centerYAnchor),
            textos.trailingAnchor.constraint(equalTo: flecha.leadingAnchor, constant: -10),

            flecha.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -16),
            flecha.centerYAnchor.constraint(equalTo: tarjeta.centerYAnchor),
            flecha.widthAnchor.constraint(equalToConstant: 12),
            flecha.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
