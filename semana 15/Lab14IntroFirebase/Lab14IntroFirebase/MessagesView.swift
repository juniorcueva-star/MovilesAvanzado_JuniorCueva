//
//  MessagesView.swift
//  Lab14IntroFirebase
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI
import FirebaseAuth

// Chat general: todos los usuarios escriben en la misma sala
struct MessagesView: View {
    @StateObject private var databaseService = DatabaseService()
    @State private var newMessage = ""

    // Email del usuario que inició sesión
    private var currentEmail: String {
        Auth.auth().currentUser?.email ?? ""
    }

    // Cantidad de usuarios distintos que escribieron en el chat
    private var participants: Int {
        Set(databaseService.messages.map { $0.userEmail }).count
    }

    var body: some View {
        VStack(spacing: 0) {
            // Messages list
            MessagesListView(
                messages: databaseService.messages,
                currentEmail: currentEmail
            )

            // New message input
            ChatInputBar(text: $newMessage) { text in
                databaseService.addMessage(text: text)
            }
        }
        .background(AppBackground())
        .toolbar {
            ToolbarItem(placement: .principal) {
                ChatTitleView(title: "General chat", subtitle: "\(participants) participants") {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                        .background(Theme.gradient)
                        .clipShape(Circle())
                }
            }
        }
        .chatNavigationBar()
        .onAppear {
            databaseService.startListening()
        }
        .onDisappear {
            databaseService.stopListening()
        }
    }
}

#Preview {
    NavigationStack {
        MessagesView()
    }
    .preferredColorScheme(.dark)
}
