//
//  ChatModels.swift
//  Lab14IntroFirebase
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import Foundation

// Perfil de un usuario registrado (colección "users")
struct AppUser: Identifiable, Codable, Hashable {
    let id: String          // uid de Firebase Authentication
    let email: String
    let displayName: String
    let photoURL: String?
}

// Resumen de una conversación privada (colección "chats")
struct ChatSummary: Identifiable, Codable {
    let id: String              // uid1_uid2 ordenados
    let participants: [String]  // uids de los dos usuarios
    let lastMessage: String
    let lastSenderEmail: String
    let lastTimestamp: Date
}

// Pantallas a las que se puede navegar desde la lista de chats
enum ChatRoute: Hashable {
    case general
    case privateChat(AppUser)
}
