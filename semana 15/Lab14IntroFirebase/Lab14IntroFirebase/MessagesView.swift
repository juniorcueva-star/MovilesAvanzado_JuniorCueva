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

    // Cantidad de usuarios distintos que escribieron en el chat
    private var participants: Int {
        Set(databaseService.messages.map { $0.userEmail }).count
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
            ZStack(alignment: .bottomTrailing) {
                AvatarView(email: currentEmail, size: 44)
                Circle()
                    .fill(Color.green)
                    .frame(width: 12, height: 12)
                    .overlay(Circle().stroke(Theme.background, lineWidth: 2))
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text("Messages")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Label("\(participants)", systemImage: "person.2.fill")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.gradient)
                        .clipShape(Capsule())
                }

                Text(currentEmail)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Button {
                try? Auth.auth().signOut()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
            }
            .buttonStyle(SignOutButtonStyle())
            .accessibilityLabel("Sign Out")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Theme.cardBorder)
                .frame(height: 1)
        }
    }

    // MARK: - Messages list
    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 10) {
                    if databaseService.messages.isEmpty {
                        emptyState
                            .padding(.top, 120)
                    }

                    ForEach(Array(databaseService.messages.enumerated()), id: \.element.id) { index, message in
                        // Separador cuando cambia el día
                        if showsDaySeparator(at: index) {
                            DaySeparator(date: message.timestamp)
                        }

                        MessageBubble(message: message, isMine: message.userEmail == currentEmail)
                            .id(message.id)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(16)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: databaseService.messages.count)
            }
            .scrollDismissesKeyboard(.interactively)
            .sensoryFeedback(.impact(weight: .light), trigger: databaseService.messages.count)
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

    private func showsDaySeparator(at index: Int) -> Bool {
        guard index > 0 else { return true }
        let previous = databaseService.messages[index - 1].timestamp
        let current = databaseService.messages[index].timestamp
        return !Calendar.current.isDate(previous, inSameDayAs: current)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Theme.card)
                    .frame(width: 96, height: 96)
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Theme.gradient)
            }
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
        HStack(alignment: .bottom, spacing: 10) {
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
                .submitLabel(.send)
                .onSubmit {
                    sendMessage()
                }

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
            .opacity(trimmedMessage.isEmpty ? 0.45 : 1)
            .scaleEffect(trimmedMessage.isEmpty ? 0.9 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: trimmedMessage.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Theme.cardBorder)
                .frame(height: 1)
        }
    }

    private func sendMessage() {
        guard !trimmedMessage.isEmpty else { return }
        databaseService.addMessage(text: trimmedMessage)
        newMessage = ""
    }
}

// MARK: - Day separator
struct DaySeparator: View {
    let date: Date

    private var label: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Today" }
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        return date.formatted(.dateTime.day().month(.abbreviated).year())
    }

    var body: some View {
        Text(label)
            .font(.caption.weight(.semibold))
            .foregroundStyle(Theme.textSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(Theme.card)
            .clipShape(Capsule())
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
    }
}

// MARK: - Message bubble
struct MessageBubble: View {
    let message: Message
    let isMine: Bool

    // Esquinas redondeadas con una "cola" del lado de quien escribe
    private var bubbleShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: 20,
            bottomLeadingRadius: isMine ? 20 : 6,
            bottomTrailingRadius: isMine ? 6 : 20,
            topTrailingRadius: 20,
            style: .continuous
        )
    }

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
                        .lineLimit(1)
                }

                Text(message.text)
                    .font(.body)
                    .foregroundStyle(.white)

                HStack(spacing: 4) {
                    Text(message.timestamp, style: .time)
                    if isMine {
                        Image(systemName: "checkmark")
                    }
                }
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.65))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(bubbleBackground)
            .clipShape(bubbleShape)
            .overlay(
                bubbleShape
                    .stroke(isMine ? Color.clear : Theme.cardBorder, lineWidth: 1)
            )
            .shadow(color: isMine ? Theme.pink.opacity(0.25) : .clear, radius: 8, y: 4)

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
