//
//  CustomProgressView.swift
//  F1App
//
//  Created by Arman Husic on 7/19/24.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        VStack {
            ProgressView()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3, alignment: .center)
                .background(.white.opacity(0.25))
                .tint(.green)
                .font(.largeTitle)
        }
        .cornerRadius(24.0)
    }

}

#Preview {
    CustomProgressView()
}
