//
//  ContentView.swift
//  Semana13_API
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                Text(user.name) // Mostrar solo el nombre
            }
            .navigationTitle("Usuarios - API")
            .onAppear {
                // Llama a la función fetchUsers() del ViewModel que se encarga de realizar la petición a la API
                viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    ContentView()
}
