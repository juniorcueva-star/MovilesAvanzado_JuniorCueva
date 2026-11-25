//
//  PrivateChatView.swift
//  Lab14IntroFirebase
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI
import FirebaseAuth

// Conversación privada entre el usuario actual y otro usuario
struct PrivateChatView: View {
    @StateObject private var chatService: PrivateChatService
    @State private var newMessage = ""

    private let otherUser: AppUser

    init(otherUser: AppUser) {
        self.otherUser = otherUser
        _chatService = StateObject(wrappedValue: PrivateChatService(otherUser: otherUser))
    }

    private var currentEmail: String {
        Auth.auth().currentUser?.email ?? ""
    }

    var body: some View {
        VStack(spacing: 0) {
            MessagesListView(
                messages: chatService.messages,
                currentEmail: currentEmail,
                showsSender: false,
                emptyIcon: "hand.wave.fill",
                emptyTitle: "Say hi to \(otherUser.displayName)",
                emptySubtitle: "Only you and \(otherUser.displayName) can see this conversation."
            )

            ChatInputBar(
                text: $newMessage,
                onSend: { text in
                    chatService.send(text: text)
                },
                onSendImage: { imageData in
                    chatService.send(text: "", imageData: imageData)
                }
            )
        }
        .background(AppBackground())
        .toolbar {
            ToolbarItem(placement: .principal) {
                ChatTitleView(title: otherUser.displayName, subtitle: otherUser.email) {
                    AvatarView(email: otherUser.email, size: 34, photoURL: otherUser.photoURL)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "lock.fill")
                    .font(.footnote)
                    .foregroundStyle(Theme.orange)
                    .accessibilityLabel("Private chat")
            }
        }
        .chatNavigationBar()
        .onAppear {
            chatService.startListening()
        }
        .onDisappear {
            chatService.stopListening()
        }
    }
}

#Preview {
    NavigationStack {
        PrivateChatView(otherUser: AppUser(id: "demo", email: "raul@gmail.com", displayName: "raul", photoURL: nil))
    }
    .preferredColorScheme(.dark)
}
