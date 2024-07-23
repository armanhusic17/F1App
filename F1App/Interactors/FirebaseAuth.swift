//
//  FirebaseCode.swift
//  F1App
//
//  Created by Arman Husic on 11/28/23.
//

import FirebaseFirestore
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

struct FirebaseAuth {
    // Google Sign In
    func signUpWithGoogle(thisSelf: UserAuth, completion: @escaping (Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: thisSelf) { result, error in
            guard error == nil else {
                // ...
                print("error in the first part of sign in")
                completion(false)
                return
            }

            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                print("error in the user part of sign in")
                completion(false)
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Firebase sign in error \(error)")
                    completion(false)
                    return
                }
                // successful sign in
                completion(true)
            }
        }
    } // end signUpWithGoogle
    
    // Delete User as required by App Store Guidelines
    func deleteUserAccount(completion: @escaping (Bool) -> Void) {
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
              print("failed to delete the user \(error)")
          } else {
            // Account deleted.
              do {
                  try Auth.auth().signOut()
                  print("Successfully Signed user out & deleted account")
                  completion(true)
              } catch {
                  print("Failed to sign out successfully \(error)")
                  completion(true)
              }
          }
        }
    } // End Google Sign In    
}
