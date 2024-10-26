//
//  MyAccountViewModel.swift
//  F1App
//
//  Created by Arman Husic on 7/22/24.
//

import SwiftUI

class MyAccountViewModel: ObservableObject {
    @Published internal var showAlert = false
    internal let firebaseCode = FirebaseAuth()
    
    internal func randomTyreColor() -> Color {
        let colors: [Color] = [.red, .white, .yellow]
        return colors.randomElement() ?? .white
    }
    
    @MainActor internal func navigateToUserAuth() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        window.rootViewController = UIStoryboard(name: "userStory", bundle: nil).instantiateInitialViewController()
        window.makeKeyAndVisible()
    }
}
