//
//  CampoClave.swift
//  Compras
//
//  Campo de clave con boton de ojo para mostrarla u ocultarla.
//  Empieza oculta (SecureField) y se usa en el login y en el registro.
//

import SwiftUI

struct CampoClave: View {
    let titulo: String
    @Binding var texto: String

    /// false = oculta (por defecto), true = visible
    @State private var visible = false

    var body: some View {
        HStack {
            Group {
                if visible {
                    TextField(titulo, text: $texto)
                } else {
                    SecureField(titulo, text: $texto)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            Button {
                visible.toggle()
            } label: {
                Image(systemName: visible ? "eye.slash" : "eye")
                    .foregroundStyle(.secondary)
            }
            // borderless: en un Form solo se pulsa el ojo, no toda la fila
            .buttonStyle(.borderless)
            .accessibilityLabel(visible ? "Ocultar clave" : "Mostrar clave")
        }
    }
}

