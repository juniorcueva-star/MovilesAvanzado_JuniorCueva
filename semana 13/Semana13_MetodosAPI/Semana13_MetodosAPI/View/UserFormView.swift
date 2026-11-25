//
//  UserFormView.swift
//  Semana13_MetodosAPI
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI

struct UserFormView: View {
    @Environment(\.dismiss) var dismiss

    @State var name: String
    @State var email: String
    var isEditing: Bool
    var avatarId: Int = 0
    var onSubmit: (String, String) -> Void

    // Solo se puede guardar si ambos campos tienen texto
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // Vista previa del avatar
                    VStack(spacing: 10) {
                        AvatarView(name: name.isEmpty ? "?" : name, id: avatarId, size: 88)
                        Text(name.isEmpty ? "Nuevo usuario" : name)
                            .font(.title3.bold())
                            .multilineTextAlignment(.center)
                        Text(isEditing ? "Modifica los datos del usuario" : "Completa los datos para registrarlo")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 16)

                    VStack(spacing: 18) {
                        FormField(title: "Nombre", icon: "person.fill", text: $name)
                        FormField(title: "Email", icon: "envelope.fill", text: $email, keyboard: .emailAddress)
                    }

                    PrimaryButton(title: "Guardar", icon: "checkmark") {
                        save()
                    }
                    .disabled(!isValid)
                    .opacity(isValid ? 1 : 0.5)
                }
                .padding(20)
            }
            .background(Theme.background)
            .navigationTitle(isEditing ? "Editar Usuario" : "Nuevo Usuario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        save()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isValid)
                }
            }
        }
    }

    private func save() {
        onSubmit(name.trimmingCharacters(in: .whitespaces),
                 email.trimmingCharacters(in: .whitespaces))
        dismiss()
    }
}

#Preview {
    UserFormView(name: "", email: "", isEditing: false) { _, _ in }
}
