//
//  ViewController.swift
//  Semana07_A
//
//  autor:junior cueva  14/10/26
//

import UIKit

class ViewController: UIViewController,
                      UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaProfesores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda")!
        cell.textLabel?.text = listaProfesores[indexPath.row].nombre
        cell.detailTextLabel?.text = listaProfesores[indexPath.row].cargo
        if let foto = listaProfesores[indexPath.row].foto {
            cell.imageView?.image = avatarCuadrado(foto)
        }
        return cell
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var listaProfesores = [
        Profesor(nombre: "Jaime Gomez", cargo: "Coordinador de Software", foto: UIImage(named: "avatar1")),
        Profesor(nombre: "Jaime Farfan", cargo: "Docente de Software TC", foto: UIImage(named: "avatar2")),
        Profesor(nombre: "Juan León", cargo: "Docente de Software TC", foto: UIImage(named: "avatar3")),
        Profesor(nombre: "Silvia Montoya", cargo: "Docente de Software TC", foto: UIImage(named: "avatar4")),
        Profesor(nombre: "Theobaldo Diaz", cargo: "Docente de Software TC", foto: UIImage(named: "avatar5")),
        Profesor(nombre: "Elliot Garamendi", cargo: "Docente de Software TC", foto: UIImage(named: "avatar6")),
        Profesor(nombre: "junior cueva", cargo: "Docente de Redes TC", foto: UIImage(named: "avatar7"))
    ]

    
    private func avatarCuadrado(_ imagen: UIImage) -> UIImage {
        let lado: CGFloat = 56
        let escala = max(lado / imagen.size.width, lado / imagen.size.height)
        let ancho = imagen.size.width * escala
        let alto = imagen.size.height * escala

        return UIGraphicsImageRenderer(size: CGSize(width: lado, height: lado)).image { _ in
            imagen.draw(in: CGRect(
                x: (lado - ancho) / 2,
                y: (lado - alto) / 2,
                width: ancho,
                height: alto
            ))
        }
    }
}

