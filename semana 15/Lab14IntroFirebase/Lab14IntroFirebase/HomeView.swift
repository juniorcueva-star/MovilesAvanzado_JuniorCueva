//
//  HomeView.swift
//  Lab14IntroFirebase
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI
import FirebaseAuth

// Pantalla principal: perfil, chat general y chats privados
struct HomeView: View {
    @StateObject private var chatService = ChatService()
    @State private var searchText = ""
    @State private var showSignOutConfirm = false

    private var currentUser: User? {
        Auth.auth().currentUser
    }

    private var myEmail: String {
        currentUser?.email ?? ""
    }

    private var myName: String {
        currentUser?.displayName ?? String(myEmail.split(separator: "@").first ?? "User")
    }

    private var isGoogleAccount: Bool {
        currentUser?.providerData.contains { $0.providerID == "google.com" } ?? false
    }

    // Personas filtradas por la búsqueda: primero las de conversación más reciente
    private var people: [AppUser] {
        let filtered = chatService.users.filter { user in
            searchText.isEmpty
                || user.displayName.localizedCaseInsensitiveContains(searchText)
                || user.email.localizedCaseInsensitiveContains(searchText)
        }
        return filtered.sorted { a, b in
            let dateA = chatService.chats[a.id]?.lastTimestamp
            let dateB = chatService.chats[b.id]?.lastTimestamp
            switch (dateA, dateB) {
            case let (x?, y?):
                return x > y
            case (.some, .none):
                return true
            case (.none, .some):
                return false
            default:
                return a.displayName.lowercased() < b.displayName.lowercased()
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    profileCard

                    sectionTitle("Groups")
                    NavigationLink(value: ChatRoute.general) {
                        GeneralChatRow()
                    }
                    .buttonStyle(.plain)

                    sectionTitle("Private chats", count: people.count)
                    if people.isEmpty {
                        emptyPeople
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(people) { user in
                                NavigationLink(value: ChatRoute.privateChat(user)) {
                                    ConversationRow(
                                        user: user,
                                        summary: chatService.chats[user.id],
                                        myEmail: myEmail
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .background(AppBackground())
            .navigationTitle("Chats")
            .searchable(text: $searchText, prompt: "Search people")
            .navigationDestination(for: ChatRoute.self) { route in
                switch route {
                case .general:
                    MessagesView()
                case .privateChat(let user):
                    PrivateChatView(otherUser: user)
                }
            }
            .confirmationDialog("Do you want to sign out?", isPresented: $showSignOutConfirm, titleVisibility: .visible) {
                Button("Sign Out", role: .destructive) {
                    signOut()
                }
            }
        }
        .onAppear {
            chatService.start()
        }
        .onDisappear {
            chatService.stop()
        }
    }

    // MARK: - Perfil
    private var profileCard: some View {
        HStack(spacing: 14) {
            ZStack(alignment: .bottomTrailing) {
                AvatarView(email: myEmail, size: 56, photoURL: currentUser?.photoURL?.absoluteString)
                Circle()
                    .fill(Color.green)
                    .frame(width: 14, height: 14)
                    .overlay(Circle().stroke(Theme.background, lineWidth: 2))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(myName)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(myEmail)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(1)
                Label(isGoogleAccount ? "Google account" : "Email account",
                      systemImage: isGoogleAccount ? "g.circle.fill" : "envelope.fill")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(Theme.orange)
            }

            Spacer()

            Button {
                showSignOutConfirm = true
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
            }
            .buttonStyle(SignOutButtonStyle())
            .accessibilityLabel("Sign Out")
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Theme.cardBorder, lineWidth: 1)
        )
    }

    private func sectionTitle(_ title: String, count: Int? = nil) -> some View {
        HStack(spacing: 8) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.textSecondary)
            if let count {
                Text("\(count)")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(Theme.gradient)
                    .clipShape(Capsule())
            }
        }
        .padding(.leading, 4)
    }

    private var emptyPeople: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.2.slash.fill")
                .font(.system(size: 34))
                .foregroundStyle(Theme.gradient)
            Text(searchText.isEmpty ? "No other users yet" : "No results")
                .font(.headline)
                .foregroundStyle(.white)
            Text(searchText.isEmpty
                 ? "When someone else signs up, they will appear here."
                 : "Try another name or email.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }

    private func signOut() {
        chatService.stop()
        try? Auth.auth().signOut()
    }
}

// MARK: - Fila del chat general
struct GeneralChatRow: View {
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 50, height: 50)
                .background(Theme.gradient)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text("General chat")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Everyone in App01-Lab14")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(14)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Theme.cardBorder, lineWidth: 1)
        )
    }
}

// MARK: - Fila de una conversación privada
struct ConversationRow: View {
    let user: AppUser
    let summary: ChatSummary?
    let myEmail: String

    private var preview: String {
        guard let summary else { return "Tap to start a private chat" }
        let prefix = summary.lastSenderEmail == myEmail ? "You: " : ""
        return prefix + summary.lastMessage
    }

    private var timeText: String {
        guard let date = summary?.lastTimestamp else { return "" }
        if Calendar.current.isDateInToday(date) {
            return date.formatted(date: .omitted, time: .shortened)
        }
        if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        }
        return date.formatted(.dateTime.day().month(.abbreviated))
    }

    var body: some View {
        HStack(spacing: 14) {
            AvatarView(email: user.email, size: 50, photoURL: user.photoURL)

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(user.displayName)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Spacer()
                    Text(timeText)
                        .font(.caption2)
                        .foregroundStyle(Theme.textSecondary)
                }
                Text(preview)
                    .font(.subheadline)
                    .foregroundStyle(summary == nil ? Theme.orange.opacity(0.85) : Theme.textSecondary)
                    .lineLimit(1)
                Text(user.email)
                    .font(.caption2)
                    .foregroundStyle(Theme.textSecondary.opacity(0.7))
                    .lineLimit(1)
            }
        }
        .padding(14)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Theme.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
