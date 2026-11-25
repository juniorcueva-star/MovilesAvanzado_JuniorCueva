//
//  ChatService.swift
//  Lab14IntroFirebase
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// Usuarios registrados y conversaciones privadas del usuario actual
class ChatService: ObservableObject {

    private let db = Firestore.firestore()
    private var listeners: [ListenerRegistration] = []

    @Published var users: [AppUser] = []
    @Published var chats: [String: ChatSummary] = [:]   // clave: uid del otro usuario

    // Guarda (o actualiza) el perfil del usuario que inició sesión
    static func saveCurrentUser() {
        guard let user = Auth.auth().currentUser else { return }

        let email = user.email ?? "unknown"
        let name = user.displayName ?? String(email.split(separator: "@").first ?? "User")
        let profile = AppUser(
            id: user.uid,
            email: email,
            displayName: name,
            photoURL: user.photoURL?.absoluteString
        )

        do {
            try Firestore.firestore().collection("users").document(user.uid).setData(from: profile)
        } catch {
            print("Error saving user: \(error)")
        }
    }

    // Id de la conversación entre dos usuarios (siempre el mismo sin importar el orden)
    static func chatId(_ uid1: String, _ uid2: String) -> String {
        [uid1, uid2].sorted().joined(separator: "_")
    }

    // Escucha en tiempo real los usuarios y las conversaciones
    func start() {
        stop()
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let usersListener = db.collection("users")
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error getting users: \(error)")
                    return
                }
                let all = snapshot?.documents.compactMap { try? $0.data(as: AppUser.self) } ?? []
                self?.users = all.filter { $0.id != uid }
            }

        let chatsListener = db.collection("chats")
            .whereField("participants", arrayContains: uid)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error getting chats: \(error)")
                    return
                }
                var result: [String: ChatSummary] = [:]
                let summaries = snapshot?.documents.compactMap { try? $0.data(as: ChatSummary.self) } ?? []
                for chat in summaries {
                    if let otherUid = chat.participants.first(where: { $0 != uid }) {
                        result[otherUid] = chat
                    }
                }
                self?.chats = result
            }

        listeners = [usersListener, chatsListener]
    }

    func stop() {
        listeners.forEach { $0.remove() }
        listeners = []
    }
}

// Mensajes de una conversación privada entre dos usuarios
class PrivateChatService: ObservableObject {

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    let otherUser: AppUser
    let chatId: String

    @Published var messages: [Message] = []

    init(otherUser: AppUser) {
        self.otherUser = otherUser
        let myUid = Auth.auth().currentUser?.uid ?? ""
        self.chatId = ChatService.chatId(myUid, otherUser.id)
    }

    // Ruta: chats/{chatId}/messages
    private var messagesRef: CollectionReference {
        db.collection("chats").document(chatId).collection("messages")
    }

    func startListening() {
        listener?.remove()
        listener = messagesRef
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error getting private messages: \(error)")
                    return
                }
                self?.messages = snapshot?.documents.compactMap { document in
                    try? document.data(as: Message.self)
                } ?? []
            }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
    }

    func send(text: String, imageData: Data? = nil) {
        guard let me = Auth.auth().currentUser else { return }

        let message = Message(
            id: UUID().uuidString,
            text: text,
            userEmail: me.email ?? "Unknown",
            timestamp: Date(),
            imageData: imageData
        )

        // Resumen para la lista de chats (último mensaje y hora)
        let summary = ChatSummary(
            id: chatId,
            participants: [me.uid, otherUser.id],
            lastMessage: imageData == nil ? text : "📷 Photo",
            lastSenderEmail: message.userEmail,
            lastTimestamp: message.timestamp
        )

        do {
            try messagesRef.document(message.id).setData(from: message)
            try db.collection("chats").document(chatId).setData(from: summary)
        } catch {
            print("Error sending private message: \(error)")
        }
    }
}
