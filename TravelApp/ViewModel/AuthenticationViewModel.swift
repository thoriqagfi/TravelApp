//
//  AuthenticationViewModel.swift
//  TravelApp
//
//  Created by Agfi on 25/05/24.
//

import SwiftUI
import AuthenticationServices
import Firebase
import CryptoKit

class AuthenticationViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var nonce: String?
    
    @AppStorage("log_Status") private var logStatus: Bool = true
    
    func showError(_ message: String) {
        errorMessage = message
        showAlert.toggle()
        isLoading = false
    }
    
    func loginWithFirebase(_ authorization: ASAuthorization) {
        // Showing loading screen until login success with Firebase
        isLoading = true
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce else {
                showError("Invalid state: A login callback was received, but no login request was sent.")
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                showError("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                showError("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    self.showError(error.localizedDescription)
                    return
                }
                // User is signed in to Firebase with Apple.
                // Push user to HomeView
                self.logStatus = true
                self.isLoading = false
            }
        }
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func handleSuccessfulLogin(with authorization: ASAuthorization) {
        if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print(userCredential.user)
            
            if userCredential.authorizedScopes.contains(.fullName) {
                print(userCredential.fullName?.givenName ?? "No given name")
            }
            if userCredential.authorizedScopes.contains(.email) {
                print(userCredential.email ?? "No email")
            }
        }
    }
    
    func handleLoginError(with error: Error) {
        print("Could not authenticate: \(error.localizedDescription)")
    }
}
