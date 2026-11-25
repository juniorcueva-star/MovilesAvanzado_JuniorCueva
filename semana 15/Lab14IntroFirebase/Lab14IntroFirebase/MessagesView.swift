//
//  MessagesView.swift
//  Lab14IntroFirebase
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI
import FirebaseAuth

struct MessagesView: View {
    @StateObject private var databaseService = DatabaseService()
    @State private var newMessage = ""

    // Email del usuario que inició sesión
    private var currentEmail: String {
        Auth.auth().currentUser?.email ?? ""
    }

    // Texto sin espacios al inicio ni al final
    private var trimmedMessage: String {
        newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            messagesList
            inputBar
        }
        .onAppear {
            databaseService.startListening()
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack(spacing: 12) {
            AvatarView(email: currentEmail, size: 42)

            VStack(alignment: .leading, spacing: 2) {
                Text("Messages")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 7, height: 7)
                    Text(currentEmail)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Button {
                try? Auth.auth().signOut()
            } label: {
                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
            }
            .buttonStyle(SignOutButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
    }

    // MARK: - Messages list
    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    if databaseService.messages.isEmpty {
                        emptyState
                            .padding(.top, 120)
                    }

                    ForEach(databaseService.messages) { message in
                        MessageBubble(message: message, isMine: message.userEmail == currentEmail)
                            .id(message.id)
                    }
                }
                .padding(16)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: databaseService.messages.count) {
                // Baja automáticamente al último mensaje
                if let last = databaseService.messages.last {
                    withAnimation(.easeOut) {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 44))
                .foregroundStyle(Theme.gradient)
            Text("No messages yet")
                .font(.headline)
                .foregroundStyle(.white)
            Text("Send the first message to start the chat.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
        }
    }

    // MARK: - New message input
    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Type a message...", text: $newMessage, axis: .vertical)
                .lineLimit(1...4)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Theme.cardBorder, lineWidth: 1)
                )

            Button {
                sendMessage()
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 46, height: 46)
                    .background(Theme.gradient)
                    .clipShape(Circle())
                    .shadow(color: Theme.pink.opacity(0.4), radius: 10, y: 5)
            }
            .disabled(trimmedMessage.isEmpty)
            .opacity(trimmedMessage.isEmpty ? 0.5 : 1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
    }

    private func sendMessage() {
        guard !trimmedMessage.isEmpty else { return }
        databaseService.addMessage(text: trimmedMessage)
        newMessage = ""
    }
}

// MARK: - Message bubble
struct MessageBubble: View {
    let message: Message
    let isMine: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isMine {
                Spacer(minLength: 50)
            } else {
                AvatarView(email: message.userEmail, size: 30)
            }

            VStack(alignment: isMine ? .trailing : .leading, spacing: 4) {
                if !isMine {
                    Text(message.userEmail)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Theme.orange)
                }

                Text(message.text)
                    .font(.body)
                    .foregroundStyle(.white)

                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.65))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(bubbleBackground)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            if !isMine {
                Spacer(minLength: 50)
            }
        }
    }

    @ViewBuilder
    private var bubbleBackground: some View {
        if isMine {
            Theme.gradient
        } else {
            Theme.card
        }
    }
}

#Preview {
    ZStack {
        AppBackground()
        MessagesView()
    }
    .preferredColorScheme(.dark)
}
