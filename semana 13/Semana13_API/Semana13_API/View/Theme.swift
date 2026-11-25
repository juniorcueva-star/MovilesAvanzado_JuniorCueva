//
//  Theme.swift
//  Semana13_API
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI

// Colores y degradados que usa toda la app
enum Theme {
    static let primary = Color(red: 0.35, green: 0.30, blue: 0.95)    // índigo
    static let secondary = Color(red: 0.62, green: 0.32, blue: 0.98)  // violeta

    static let background = Color(.systemGroupedBackground)
    static let card = Color(.secondarySystemGroupedBackground)
    static let cardBorder = Color.white.opacity(0.08)  // borde fino para separar las tarjetas del fondo

    static let gradient = LinearGradient(
        colors: [primary, secondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Paletas para los avatares (se elige una según el id del usuario)
    private static let avatarPalettes: [[Color]] = [
        [Color(red: 0.36, green: 0.42, blue: 0.98), Color(red: 0.55, green: 0.33, blue: 0.97)],
        [Color(red: 0.98, green: 0.45, blue: 0.45), Color(red: 0.98, green: 0.62, blue: 0.35)],
        [Color(red: 0.15, green: 0.72, blue: 0.62), Color(red: 0.20, green: 0.55, blue: 0.90)],
        [Color(red: 0.95, green: 0.35, blue: 0.65), Color(red: 0.62, green: 0.32, blue: 0.98)],
        [Color(red: 0.98, green: 0.70, blue: 0.20), Color(red: 0.96, green: 0.45, blue: 0.30)]
    ]

    static func avatarGradient(for id: Int) -> LinearGradient {
        let colors = avatarPalettes[abs(id) % avatarPalettes.count]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
