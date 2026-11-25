//
//  UserViewModel.swift
//  Semana13_MetodosAPI
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var searchText: String = ""

    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { user in
                user.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    // GET: Obtener todos los usuarios
    func fetchUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decodedUsers = try? JSONDecoder().decode([User].self, from: data) {
                    DispatchQueue.main.async {
                        self.users = decodedUsers
                    }
                }
            }
        }.resume()
    }
}
