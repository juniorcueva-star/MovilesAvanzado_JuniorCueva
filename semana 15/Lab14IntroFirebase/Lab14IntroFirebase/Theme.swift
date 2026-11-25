//
//  Theme.swift
//  Lab14IntroFirebase
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI

// Colores y degradados de la app (inspirados en los colores de Firebase)
enum Theme {
    static let orange = Color(red: 1.00, green: 0.57, blue: 0.10)
    static let pink = Color(red: 0.96, green: 0.27, blue: 0.42)
    static let violet = Color(red: 0.55, green: 0.36, blue: 0.98)

    static let background = Color(red: 0.05, green: 0.05, blue: 0.08)
    static let card = Color.white.opacity(0.07)
    static let cardBorder = Color.white.opacity(0.10)
    static let textSecondary = Color.white.opacity(0.6)

    static let gradient = LinearGradient(
        colors: [orange, pink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Paletas para los avatares (se elige según el email)
    private static let avatarPalettes: [[Color]] = [
        [orange, pink],
        [violet, pink],
        [Color(red: 0.15, green: 0.72, blue: 0.62), Color(red: 0.20, green: 0.55, blue: 0.90)],
        [Color(red: 0.36, green: 0.42, blue: 0.98), violet],
        [Color(red: 0.98, green: 0.70, blue: 0.20), orange]
    ]

    static func avatarGradient(for text: String) -> LinearGradient {
        let sum = text.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        let colors = avatarPalettes[sum % avatarPalettes.count]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

// Fondo oscuro con dos luces de color difuminadas
struct AppBackground: View {
    var body: some View {
        ZStack {
            Theme.background

            Circle()
                .fill(Theme.pink.opacity(0.35))
                .frame(width: 320, height: 320)
                .blur(radius: 120)
                .offset(x: -140, y: -300)

            Circle()
                .fill(Theme.violet.opacity(0.30))
                .frame(width: 300, height: 300)
                .blur(radius: 120)
                .offset(x: 160, y: 320)
        }
        .ignoresSafeArea()
    }
}

// Foto del usuario (cuentas de Google) o círculo con la inicial del email
struct AvatarView: View {
    let email: String
    var size: CGFloat = 40
    var photoURL: String? = nil

    private var initial: String {
        email.first.map { String($0).uppercased() } ?? "?"
    }

    var body: some View {
        Group {
            if let photoURL, let url = URL(string: photoURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    initialView
                }
            } else {
                initialView
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }

    private var initialView: some View {
        Text(initial)
            .font(.system(size: size * 0.42, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(Theme.avatarGradient(for: email))
    }
}

// Campo de texto con icono
struct InputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Theme.orange)
                .frame(width: 22)
            TextField(placeholder, text: $text)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(.white)
        }
        .fieldStyle()
    }
}

// Campo de contraseña con botón para mostrar u ocultar
struct PasswordField: View {
    @Binding var text: String
    @State private var isVisible = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .foregroundStyle(Theme.orange)
                .frame(width: 22)

            Group {
                if isVisible {
                    TextField("Password", text: $text)
                } else {
                    SecureField("Password", text: $text)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .foregroundStyle(.white)

            Button {
                isVisible.toggle()
            } label: {
                Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundStyle(Theme.textSecondary)
            }
            .buttonStyle(.plain)
        }
        .fieldStyle()
    }
}

extension View {
    // Estilo común de los campos: fondo translúcido y borde fino
    func fieldStyle() -> some View {
        self
            .padding(.horizontal, 16)
            .frame(height: 54)
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Theme.cardBorder, lineWidth: 1)
            )
    }
}
