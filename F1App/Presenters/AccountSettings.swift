//
//  AccountSettings.swift
//  F1App
//
//  Created by Arman Husic on 11/29/23.
//

import Foundation
import UIKit

class AccountSettings: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var accountSettingsLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var deleteAccImg: UIImageView!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var deleteAccountLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var alertButtonStack: UIStackView!
    @IBOutlet weak var alertCancelButton: UIButton!
    @IBOutlet weak var alertAcceptButton: UIButton!

    let firebaseCode = FirebaseAuth()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func formatViews(){
        self.midView.layer.borderWidth = 0.5
        self.midView.layer.borderColor = randomTyreColor()
        self.midView.layer.cornerRadius = 12
        self.alertView.layer.borderWidth = 0.5
        self.alertView.layer.borderColor = randomTyreColor()
        self.alertView.layer.cornerRadius = 12
        self.alertAcceptButton.layer.cornerRadius = 12
        self.alertCancelButton.layer.cornerRadius = 12
        self.alertAcceptButton.layer.borderColor = UIColor.red.cgColor
        self.alertAcceptButton.layer.borderWidth = 0.5
        self.alertCancelButton.layer.borderColor = UIColor.white.cgColor
        self.alertCancelButton.layer.borderWidth = 0.5
        self.alertView.isHidden = true
    }

    @IBAction func deleteAccountButtonPressed(_ sender: UIButton) {
        self.alertView.isHidden = false
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.alertView.isHidden = true
    }

    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        firebaseCode.deleteUserAccount(thisSelf: self, transitionString: "deleteAccountTransition")
    }

}

extension UIViewController {
    func randomTyreColor() -> CGColor {
        let colors = [UIColor.red.cgColor, UIColor.white.cgColor, UIColor.yellow.cgColor]
        return colors.randomElement() ?? UIColor.white.cgColor
    }
}
