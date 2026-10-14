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
        return cell
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var listaProfesores = [
        Profesor(nombre: "Jaime Gomez", cargo: "Coordinador de Software"),
        Profesor(nombre: "Jaime Farfan", cargo: "Docente de Software TC"),
        Profesor(nombre: "Juan León", cargo: "Docente de Software TC"),
        Profesor(nombre: "Silvia Montoya", cargo: "Docente de Software TC"),
        Profesor(nombre: "Theobaldo Diaz", cargo: "Docente de Software TC"),
        Profesor(nombre: "Elliot Garamendi", cargo: "Docente de Software TC"),
        Profesor(nombre: "Edwin Huerto", cargo: "Docente de Redes TC")
    ]

}

