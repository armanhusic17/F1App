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
            accountTitle
            deleteAccountButton
        }
        .ignoresSafeArea(.all)
        .padding(8)
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
        }
    }

    private var deleteAccountButton: some View {
        HStack {
            Image(systemName: "trash")
                .font(.headline)
                .padding([.leading, .top, .bottom], 16)
            Text("Delete Account")
                .font(.caption)
                .padding([.trailing, .top, .bottom], 16)
            Spacer()
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
    
    private var accountTitle: some View {
        // Top View
        HStack {
            Text("Account Settings")
                .font(.headline)
                .padding(.top)
            Spacer()
        }
    }
}

#Preview {
    MyAccount()
}
