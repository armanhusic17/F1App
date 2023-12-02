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

class UserAuth: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var appleSignInButton: ASAuthorizationAppleIDButton!
    
    var firebaseAuth = FirebaseCode()
 
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
        firebaseAuth.triggerAppleSignIn(thisSelf: self)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return view.window ?? UIWindow()
    }
    
}
