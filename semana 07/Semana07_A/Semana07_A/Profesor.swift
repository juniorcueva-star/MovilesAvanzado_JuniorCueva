//
//  Profesor.swift
//  Semana07_A
//
//  Created by Tecsup on 14/10/26.
//

import UIKit

class Profesor: NSObject {
    var nombre: String = ""
    var cargo: String = ""

    init(nombre: String, cargo: String) {
        self.nombre = nombre
        self.cargo = cargo
        super.init()
    }
}
