//
//  User.swift
//  Semana13_API
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import Foundation

// Codable: permite convertir entre esta estructura y datos JSON automáticamente.
// Identifiable: permite que SwiftUI sepa cómo identificar cada elemento en una lista.
struct User: Codable, Identifiable {
    let id: Int
    let name: String
}
