//
//  FirebaseCode.swift
//  F1App
//
//  Created by Arman Husic on 11/28/23.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices
import CryptoKit

struct FirebaseCode {
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    
    // Google Sign In
    func signUpWithGoogle(thisSelf: UIViewController){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: thisSelf) { [unowned thisSelf] result, error in
            guard error == nil else {
                // ...
                print("error in the first part of sign in")
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                print("error in the user part of sign in")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                // At this point, our user is signed in
                print("User signed in successfully")
                thisSelf.performSegue(withIdentifier: "successfulLoginTransition", sender: thisSelf)
            }
        }
    } // end signUpWithGoogle
    
    // Delete User as required by App Store Guidelines
    func deleteUserAccount(thisSelf: UIViewController, transitionString: String){
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
            // An error happened.
          } else {
            // Account deleted.
              print("Successfully deleted the account - logged out")
              thisSelf.performSegue(withIdentifier: transitionString, sender: thisSelf)
          }
        }
    }
    
    // End Google Sign In
    
    
    
    // Apple Sign In
    func authorizationController(thisSelf: UIViewController, controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Do something with the credential...
            // Save authorised user ID for future reference
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
            
            // Retrieve the secure nonce generated during Apple sign in
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            // Retrieve Apple identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Failed to fetch identity token")
                return
            }

            // Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to decode identity token")
                return
            }

            // Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
            
            // Sign in with Firebase
            Auth.auth().signIn(with: firebaseCredential) { [weak thisSelf] (authResult, error) in
                // Do something after Firebase sign in completed
                thisSelf?.performSegue(withIdentifier: "successfulLoginTransition", sender: self)
            }

        }
    }
    
    mutating func triggerAppleSignIn(thisSelf: UIViewController){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        // Generate nonce for validation after authentication successful
        self.currentNonce = randomNonceString()
        // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
        request.nonce = sha256(currentNonce!)

        // Present Apple authorization form
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = thisSelf as! any ASAuthorizationControllerDelegate
        authorizationController.presentationContextProvider = thisSelf as! any ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    
}
