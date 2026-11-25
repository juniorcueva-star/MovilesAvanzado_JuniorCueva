//
//  Components.swift
//  Semana13_AsyncAwait
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI

// Círculo con las iniciales del usuario sobre un degradado
struct AvatarView: View {
    let name: String
    let id: Int
    var size: CGFloat = 48

    private var initials: String {
        let titles = ["Mr.", "Mrs.", "Ms.", "Dr."]
        let parts = name.split(separator: " ").filter { !titles.contains(String($0)) }
        let letters = parts.prefix(2).compactMap { $0.first }
        return letters.isEmpty ? "?" : String(letters).uppercased()
    }

    var body: some View {
        Text(initials)
            .font(.system(size: size * 0.38, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(Theme.avatarGradient(for: id))
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
    }
}

// Tarjeta superior con el total de usuarios
struct HeaderCard: View {
    let total: Int

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Directorio")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.8))
                Text("\(total) usuarios")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Label("API REST · JSONPlaceholder", systemImage: "network")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white.opacity(0.85))
            }
            Spacer()
            Image(systemName: "person.3.fill")
                .font(.system(size: 42))
                .foregroundStyle(.white.opacity(0.25))
        }
        .padding(20)
        .background(Theme.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Theme.primary.opacity(0.35), radius: 16, y: 8)
    }
}

// Campo de búsqueda con icono y botón para limpiar
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Buscar usuario por nombre", text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Theme.cardBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.35), radius: 8, y: 3)
    }
}

// Fila de la lista en forma de tarjeta
struct UserRowView: View {
    let user: User

    var body: some View {
        HStack(spacing: 14) {
            AvatarView(name: user.name, id: user.id)
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                HStack(spacing: 5) {
                    Image(systemName: "envelope.fill")
                        .font(.caption2)
                    Text(user.email)
                        .font(.subheadline)
                        .lineLimit(1)
                }
                .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Theme.cardBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.35), radius: 10, y: 4)
    }
}

// Campo de texto del formulario con título e icono
struct FormField: View {
    let title: String
    let icon: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(Theme.primary)
                    .frame(width: 20)
                TextField(title, text: $text)
                    .keyboardType(keyboard)
                    .textInputAutocapitalization(keyboard == .emailAddress ? .never : .words)
                    .autocorrectionDisabled()
            }
            .padding(14)
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Theme.cardBorder, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.35), radius: 6, y: 2)
        }
    }
}

// Botón principal con degradado
struct PrimaryButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Theme.gradient)
                .clipShape(Capsule())
                .shadow(color: Theme.primary.opacity(0.4), radius: 12, y: 6)
        }
    }
}

extension View {
    // Quita el fondo y separadores de una fila para mostrarla como tarjeta
    func cleanRow(top: CGFloat = 6, bottom: CGFloat = 6) -> some View {
        self
            .listRowInsets(EdgeInsets(top: top, leading: 20, bottom: bottom, trailing: 20))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}
