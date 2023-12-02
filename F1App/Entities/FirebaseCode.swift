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
    
    
    
    
    
}
