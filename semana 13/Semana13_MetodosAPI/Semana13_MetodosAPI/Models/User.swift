//
//  User.swift
//  Semana13_MetodosAPI
//
//  Created by Junior Cueva Fabian on 24/11/26.
//  Utilizando los métodos POST - PUT - DELETE
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
}
