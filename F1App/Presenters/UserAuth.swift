//
//  UserAuth.swift
//  F1App
//
//  Created by Arman Husic on 11/29/23.
//

import Foundation
import UIKit
import GoogleSignIn

class UserAuth: UIViewController {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    let firebaseAuth = FirebaseCode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatViews()
    }
    
    func randomTyreColor() -> CGColor {
        let colors = [UIColor.red.cgColor, UIColor.white.cgColor, UIColor.yellow.cgColor]
        return colors.randomElement() ?? UIColor.white.cgColor
    }
    
    func formatViews(){
        self.googleSignInButton.layer.cornerRadius = 12
        self.googleSignInButton.layer.borderWidth = 1
        self.googleSignInButton.layer.borderColor = randomTyreColor()
    }
    
    @IBAction func googleSignInButtonPressed(_ sender: GIDSignInButton) {
        firebaseAuth.signUpWithGoogle(thisSelf: self)
    }
    
    
}
