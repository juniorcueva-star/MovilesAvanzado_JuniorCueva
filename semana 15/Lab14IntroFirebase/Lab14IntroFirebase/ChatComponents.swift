//
//  ChatComponents.swift
//  Lab14IntroFirebase
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI

// MARK: - Lista de mensajes (chat general y chats privados)
struct MessagesListView: View {
    let messages: [Message]
    let currentEmail: String
    var showsSender: Bool = true
    var emptyIcon: String = "bubble.left.and.bubble.right.fill"
    var emptyTitle: String = "No messages yet"
    var emptySubtitle: String = "Send the first message to start the chat."

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 10) {
                    if messages.isEmpty {
                        emptyState
                            .padding(.top, 120)
                    }

                    ForEach(Array(messages.enumerated()), id: \.element.id) { index, message in
                        // Separador cuando cambia el día
                        if showsDaySeparator(at: index) {
                            DaySeparator(date: message.timestamp)
                        }

                        MessageBubble(
                            message: message,
                            isMine: message.userEmail == currentEmail,
                            showsSender: showsSender
                        )
                        .id(message.id)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(16)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: messages.count)
            }
            .scrollDismissesKeyboard(.interactively)
            .sensoryFeedback(.impact(weight: .light), trigger: messages.count)
            .onAppear {
                scrollToLast(proxy, animated: false)
            }
            .onChange(of: messages.count) {
                // Baja automáticamente al último mensaje
                scrollToLast(proxy, animated: true)
            }
        }
    }

    private func scrollToLast(_ proxy: ScrollViewProxy, animated: Bool) {
        guard let last = messages.last else { return }
        if animated {
            withAnimation(.easeOut) {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        } else {
            proxy.scrollTo(last.id, anchor: .bottom)
        }
    }

    private func showsDaySeparator(at index: Int) -> Bool {
        guard index > 0 else { return true }
        let previous = messages[index - 1].timestamp
        let current = messages[index].timestamp
        return !Calendar.current.isDate(previous, inSameDayAs: current)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Theme.card)
                    .frame(width: 96, height: 96)
                Image(systemName: emptyIcon)
                    .font(.system(size: 40))
                    .foregroundStyle(Theme.gradient)
            }
            Text(emptyTitle)
                .font(.headline)
                .foregroundStyle(.white)
            Text(emptySubtitle)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 30)
    }
}

// MARK: - Barra para escribir y enviar
struct ChatInputBar: View {
    @Binding var text: String
    let onSend: (String) -> Void

    private var trimmed: String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            TextField("Type a message...", text: $text, axis: .vertical)
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
                send()
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 46, height: 46)
                    .background(Theme.gradient)
                    .clipShape(Circle())
                    .shadow(color: Theme.pink.opacity(0.4), radius: 10, y: 5)
            }
            .disabled(trimmed.isEmpty)
            .opacity(trimmed.isEmpty ? 0.45 : 1)
            .scaleEffect(trimmed.isEmpty ? 0.9 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: trimmed.isEmpty)
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

    private func send() {
        guard !trimmed.isEmpty else { return }
        onSend(trimmed)
        text = ""
    }
}

// MARK: - Título de la barra de navegación del chat
struct ChatTitleView<Icon: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let icon: () -> Icon

    var body: some View {
        HStack(spacing: 10) {
            icon()
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - Separador por día
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

// MARK: - Burbuja de mensaje
struct MessageBubble: View {
    let message: Message
    let isMine: Bool
    var showsSender: Bool = true

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
            } else if showsSender {
                AvatarView(email: message.userEmail, size: 30)
            }

            VStack(alignment: isMine ? .trailing : .leading, spacing: 4) {
                if !isMine && showsSender {
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

// MARK: - Estilo de la barra de navegación en los chats
extension View {
    func chatNavigationBar() -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}
