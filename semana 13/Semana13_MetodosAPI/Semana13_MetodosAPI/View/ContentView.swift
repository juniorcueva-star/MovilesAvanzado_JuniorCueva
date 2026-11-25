//
//  ContentView.swift
//  Semana13_MetodosAPI
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Buscar usuario por nombre", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                List(viewModel.filteredUsers) { user in
                    VStack(alignment: .leading) {
                        Text(user.name).font(.headline)
                        Text(user.email).font(.subheadline).foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Usuarios")
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    ContentView()
}
