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
import SwiftUI

class UserAuth: UIViewController, AuthModelDelegate {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var appleSignInButton: ASAuthorizationAppleIDButton!
    var activitySpinner: UIActivityIndicatorView?
    let model = AuthModel()
    var firebaseAuth = FirebaseAuth()

    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
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
        showSpinner()
        firebaseAuth.signUpWithGoogle(thisSelf: self) { success in
            if success {
                DispatchQueue.main.async {
                    self.hideSpinner()
                    let homeScreenView = HomeScreen()
                    let hostingController = UIHostingController(rootView: homeScreenView)
                    hostingController.modalPresentationStyle = .fullScreen
                    self.present(hostingController, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func appleSignInButtonpressed(_ sender: ASAuthorizationAppleIDButton) {
        print("Apple Sign In Button pressed")
        showSpinner()
        model.triggerAppleSignIn(model: model)
    }

    func didCompleteSignIn(_ viewController: UIViewController) {
        hideSpinner()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

    func showSpinner() {
        activitySpinner = UIActivityIndicatorView(style: .large)
        activitySpinner?.color = UIColor.green
        activitySpinner?.center = self.view.center
        activitySpinner?.startAnimating()
        self.view.addSubview(activitySpinner ?? UIActivityIndicatorView())
    }

    func hideSpinner() {
        activitySpinner?.stopAnimating()
        activitySpinner?.removeFromSuperview()
    }
}
