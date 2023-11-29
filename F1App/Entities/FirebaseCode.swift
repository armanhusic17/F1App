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

struct FirebaseCode {
    
    
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Fatal error - no client id")
            fatalError()
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
            print("There is no view controller")
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
//            guard let idToken = user.idToken else {
//
//            }
        } catch {
            
        }
        
        return false
    }
    
    
    func signUpWithGoogle(thisSelf: UIViewController){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: thisSelf) { [unowned thisSelf] result, error in
            guard error == nil else {
                // ...
                print("Error")
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                print("Error")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                // At this point, our user is signed in
                print("User signed in successfully")
            }
                
            
            
        }
    }
    
}
