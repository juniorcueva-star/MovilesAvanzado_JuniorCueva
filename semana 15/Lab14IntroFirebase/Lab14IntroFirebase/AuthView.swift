//
//  AuthView.swift
//  Lab14IntroFirebase
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var isGlowing = false
    @State private var authStateListener: AuthStateDidChangeListenerHandle?

    var body: some View {
        ZStack {
            AppBackground()

            if isSignedIn {
                // Show the chat list (general chat + private chats) when signed in
                HomeView()
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            } else {
                // Sign in form
                signInForm
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: isSignedIn)
        .alert("Message", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            checkAuthState()
        }
        .onChange(of: isSignedIn) {
            // Clear form when signing out
            if !isSignedIn {
                email = ""
                password = ""
            }
        }
    }

    // MARK: - Sign in form
    private var signInForm: some View {
        ScrollView {
            VStack(spacing: 30) {
                header

                // Tarjeta de vidrio con el formulario
                VStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome back")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)
                        Text("Use Google or your email to continue")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Opción 1: cuenta de Google con un solo botón
                    Button {
                        signInWithGoogle()
                    } label: {
                        HStack(spacing: 10) {
                            GoogleLogo()
                            Text("Continue with Google")
                        }
                    }
                    .buttonStyle(GoogleButtonStyle())
                    .disabled(isLoading)

                    orDivider

                    // Opción 2: cuenta manual con email y contraseña
                    VStack(spacing: 12) {
                        InputField(icon: "envelope.fill", placeholder: "Email", text: $email)
                        PasswordField(text: $password)
                    }

                    HStack {
                        passwordHint
                        Spacer()
                        Button("Forgot password?") {
                            resetPassword()
                        }
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Theme.orange)
                    }

                    VStack(spacing: 12) {
                        Button {
                            signIn()
                        } label: {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Label("Sign In", systemImage: "arrow.right")
                                    .labelStyle(TrailingIconLabelStyle())
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())

                        Button("Sign Up") {
                            signUp()
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    .disabled(isLoading)
                }
                .padding(22)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Theme.cardBorder, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.4), radius: 30, y: 20)

                Label("Secured by Firebase Authentication", systemImage: "checkmark.shield.fill")
                    .font(.footnote)
                    .foregroundStyle(Theme.textSecondary)
            }
            .padding(.horizontal, 24)
            .padding(.top, 56)
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private var orDivider: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Theme.cardBorder)
                .frame(height: 1)
            Text("or use your email")
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
                .fixedSize()
            Rectangle()
                .fill(Theme.cardBorder)
                .frame(height: 1)
        }
    }

    // Indica si la contraseña cumple el mínimo de 6 caracteres
    @ViewBuilder
    private var passwordHint: some View {
        if !password.isEmpty {
            let isValid = password.count >= 6
            Label("6+ characters", systemImage: isValid ? "checkmark.circle.fill" : "circle")
                .font(.footnote)
                .foregroundStyle(isValid ? Color.green : Theme.textSecondary)
        }
    }

    private var header: some View {
        VStack(spacing: 14) {
            ZStack {
                // Brillo animado detrás del logo
                Circle()
                    .fill(Theme.pink.opacity(0.45))
                    .frame(width: 120, height: 120)
                    .blur(radius: 30)
                    .scaleEffect(isGlowing ? 1.15 : 0.85)

                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Theme.gradient)
                    .frame(width: 92, height: 92)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(.white.opacity(0.25), lineWidth: 1)
                    )
                    .shadow(color: Theme.pink.opacity(0.5), radius: 22, y: 10)

                Image(systemName: "flame.fill")
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(.white)
                    .symbolEffect(.pulse, options: .repeating)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                    isGlowing = true
                }
            }

            Text("Lab 14: Firebase")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Sign in or create your account")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
        }
    }

    // MARK: - Authentication Functions
    func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }

        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                alertMessage = "Sign in failed: \(error.localizedDescription)"
                showAlert = true
                print("error.localizedDescription: '\(error.localizedDescription)'")
            } else {
                isSignedIn = true
                alertMessage = "Sign in successful!"
                showAlert = true
            }
        }
    }

    func signUp() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            return
        }

        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters"
            showAlert = true
            return
        }

        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                alertMessage = "Sign up failed: \(error.localizedDescription)"
                showAlert = true
            } else {
                isSignedIn = true
                alertMessage = "Account created successfully!"
                showAlert = true
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            isSignedIn = false
            alertMessage = "Signed out successfully"
            showAlert = true
        } catch {
            alertMessage = "Sign out failed: \(error.localizedDescription)"
            showAlert = true
        }
    }

    // MARK: - Google Sign-In
    func signInWithGoogle() {
        // El clientID viene de GoogleService-Info.plist (CLIENT_ID)
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            alertMessage = "Google Sign-In is not configured. Enable Google in Firebase and download GoogleService-Info.plist again."
            showAlert = true
            return
        }
        guard let presenter = topViewController() else { return }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        isLoading = true

        // 1. Google muestra su pantalla para elegir la cuenta
        GIDSignIn.sharedInstance.signIn(withPresenting: presenter) { result, error in
            if let error = error {
                isLoading = false
                // Si el usuario cancela no se muestra ningún error
                if (error as NSError).code != GIDSignInError.Code.canceled.rawValue {
                    alertMessage = "Google sign in failed: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }

            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                isLoading = false
                return
            }

            // 2. Con el token de Google se inicia sesión en Firebase
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { _, error in
                isLoading = false
                if let error = error {
                    alertMessage = "Sign in failed: \(error.localizedDescription)"
                    showAlert = true
                } else {
                    isSignedIn = true
                    alertMessage = "Signed in with Google!"
                    showAlert = true
                }
            }
        }
    }

    // Pantalla desde la que se presenta la ventana de Google
    private func topViewController() -> UIViewController? {
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        var top = scene?.keyWindow?.rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        return top
    }

    func resetPassword() {
        guard !email.isEmpty else {
            alertMessage = "Enter your email to reset your password"
            showAlert = true
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = "Reset failed: \(error.localizedDescription)"
            } else {
                alertMessage = "We sent a password reset link to \(email)"
            }
            showAlert = true
        }
    }

    func checkAuthState() {
        // Listen for authentication state changes and store the listener handle
        authStateListener = Auth.auth().addStateDidChangeListener { auth, user in
            // Guarda el perfil para que aparezca en la lista de chats privados
            if user != nil {
                ChatService.saveCurrentUser()
            }
            DispatchQueue.main.async {
                self.isSignedIn = user != nil
            }
        }
    }
}

// MARK: - Button Styles
struct GoogleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .white.opacity(0.15), radius: 12, y: 6)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// Letra "G" con los colores de Google
struct GoogleLogo: View {
    var body: some View {
        Text("G")
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.26, green: 0.52, blue: 0.96),
                        Color(red: 0.92, green: 0.26, blue: 0.21),
                        Color(red: 0.98, green: 0.74, blue: 0.02),
                        Color(red: 0.20, green: 0.66, blue: 0.33)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            configuration.title
            configuration.icon
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Theme.gradient)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Theme.pink.opacity(0.45), radius: 14, y: 8)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Theme.gradient, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct SignOutButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(Color.red.opacity(0.85))
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    AuthView()
        .preferredColorScheme(.dark)
}
