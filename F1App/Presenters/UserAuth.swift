//
//  UserAuth.swift
//  F1App
//
//  Created by Arman Husic on 11/29/23.
//

import Foundation
import UIKit
import AuthenticationServices
import GoogleSignIn
import FirebaseAuth
import CryptoKit

class UserAuth: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var appleSignInButton: ASAuthorizationAppleIDButton!
    
    var firebaseAuth = FirebaseAuth()
    var currentNonce: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        formatViews()
    }
    
    func formatViews(){
        self.appleSignInButton.layer.cornerRadius = 12
        self.appleSignInButton.layer.borderWidth = 0.51
        self.appleSignInButton.layer.borderColor = randomTyreColor()
        
        self.googleSignInButton.layer.cornerRadius = 12
        self.googleSignInButton.layer.borderWidth = 0.5
        self.googleSignInButton.layer.borderColor = randomTyreColor()
    }
    
    @IBAction func googleSignInButtonPressed(_ sender: GIDSignInButton) {
        firebaseAuth.signUpWithGoogle(thisSelf: self)
    }
    
    
    @IBAction func appleSignInButtonpressed(_ sender: ASAuthorizationAppleIDButton) {
        print("Apple Sign In Button pressed")
        self.triggerAppleSignIn(thisSelf: self)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? UIWindow()
    }
    
    func triggerAppleSignIn(thisSelf: UserAuth){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        // Generate nonce for validation after authentication successful
        self.currentNonce = self.randomNonceString()
        // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
        request.nonce = self.sha256(self.currentNonce!)

        // Present Apple authorization form
        DispatchQueue.main.async {
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = thisSelf
            authorizationController.presentationContextProvider = thisSelf
            authorizationController.performRequests()
        }
    }
    
    // Apple Sign In
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Do something with the credential...
            // Save authorised user ID for future reference
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
            
            // Retrieve the secure nonce generated during Apple sign in
            guard let nonce = self.currentNonce else {
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
            
            DispatchQueue.main.async {
                // Sign in with Firebase
                Auth.auth().signIn(with: firebaseCredential) { [weak self] (authResult, error) in
                    // Do something after Firebase sign in completed
                    self?.performSegue(withIdentifier: "successfulLoginTransition", sender: self)
                }
            }

        }
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

    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    
    
}
