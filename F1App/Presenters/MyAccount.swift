//
//  MyAccount.swift
//  F1App
//
//  Created by Arman Husic on 7/21/24.
//

import SwiftUI

struct MyAccount: View {
    @StateObject internal var viewModel = MyAccountViewModel()
    @State internal var alertVisible = false
    

    var body: some View {
        VStack {
            // Top View
            Text("Account Settings")
                .font(.title)
                .padding()

            // Middle View
            VStack {
                HStack {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding()
                    Text("Delete Account")
                        .font(.headline)
                        .padding()
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(viewModel.randomTyreColor(), lineWidth: 0.5)
                )
                .onTapGesture {
                    viewModel.showAlert = true
                }
            }
            .padding()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Delete Account"),
                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                primaryButton: .destructive(
                    Text("Delete")
                ) {
                    print("Account Deleted")
                    viewModel.firebaseCode.deleteUserAccount(completion: { _ in
                        viewModel.navigateToUserAuth()
                    })
                },
                secondaryButton: .cancel(
                    Text("Cancel")
                )
            )
        } // end body
    }
}

#Preview {
    MyAccount()
}
