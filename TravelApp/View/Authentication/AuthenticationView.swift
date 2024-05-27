//
//  AuthenticationView.swift
//  TravelApp
//
//  Created by Agfi on 25/05/24.
//

import SwiftUI
import AuthenticationServices

struct AuthenticationView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        NavigationStack {
            SignInWithAppleButton(.signIn) { request in
                let nonce = authenticationViewModel.randomNonceString()
                authenticationViewModel.nonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = authenticationViewModel.sha256(nonce)
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    authenticationViewModel.loginWithFirebase(authorization)
                    authenticationViewModel.handleSuccessfulLogin(with: authorization)
                case .failure(let error):
                    authenticationViewModel.showError(error.localizedDescription)
                    authenticationViewModel.handleLoginError(with: error)
                }
            }
            .frame(width: 280, height: 40)
            .alert(authenticationViewModel.errorMessage, isPresented: $authenticationViewModel.showAlert) {}
            .overlay {
                if authenticationViewModel.isLoading {
                    LoadingScreen()
                }
            }
        }
    }
    
    @ViewBuilder
    func LoadingScreen() -> some View {
        ZStack(content: {
            Rectangle()
                .fill(.ultraThinMaterial)
            ProgressView()
                .frame(width: 45, height: 45)
                .background(.background, in: .rect(cornerRadius: 5))
        })
    }
}

#Preview {
    AuthenticationView()
}
