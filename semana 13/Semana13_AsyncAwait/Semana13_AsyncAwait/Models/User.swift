//
//  User.swift
//  Semana13_AsyncAwait
//
//  Created by Junior Cueva Fabian on 24/11/26.
//  Uso de URLSession con async/await
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
}
