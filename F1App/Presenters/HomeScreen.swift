//
//  HomeScreen.swift
//  F1App
//
//  Created by Arman Husic on 2/19/24.
//

import SwiftUI
import UIKit

struct HomeScreen: View {
    
    let homeModel = HomeModel()
    @State var text: String
    
    
    struct ErgastQueryButton {
        let icon: Image?
        let label: String
        var action: () -> Void
    }
    
    let queries: [ErgastQueryButton] = [
        ErgastQueryButton(
            icon: Image(systemName: "moon.fill"),
            label: "Drivers",
            action: {
                print("Drivers Query")
        }),
        ErgastQueryButton(
            icon:Image(systemName: "moon.fill"), 
            label: "Constructors", 
            action: {
                print("Constructors Query")
                F1ApiRoutes.getConstructorStandings(seasonYear: "2024") { Success in
                    print(Success)
                    FirstResultsWrapper()
                }
        }),
        ErgastQueryButton(
            icon: Image(systemName: "moon.fill"),
            label: "Grand Prix",
            action: {
                print("Grand Prix Query")
        })
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .black, .black, .black], startPoint: .bottom, endPoint: .trailing).ignoresSafeArea()
            VStack {
                TextField("Enter Season Year", text: $text)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)

                ScrollView {
                    VStack {
                        LazyVGrid(
                            columns: [GridItem(.fixed(UIScreen.main.bounds.width / 2))],
                            spacing: 24) {
                                ForEach(queries.indices, id: \.self) { index in
                                    Button(action: queries[index].action) {
                                        HStack {
                                            queries[index].icon
                                            Text(queries[index].label)
                                        } // end hstack button
                                        .frame(width: 500, height: 500, alignment: .center)
                                        .cornerRadius(24)
                                        .foregroundColor(.white)
                                        .padding(8)
                                    }
                                    .background(
                                        LinearGradient(
                                            colors: [.black, .black, .blue.opacity(0.1), .blue.opacity(0.1), .blue.opacity(0.2)],
                                            startPoint: .bottom, endPoint: .trailing
                                        )
                                    )
                                }
                            }
                            .padding(20)
                    }
                }
                .padding(.top, 100)
                .padding(.bottom, 100)
            }
        }
    }
}

#Preview {
    HomeScreen(text: "Enter F1 Season Year")
}

struct FirstResultsWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FirstResults {
        let viewController = FirstResults()
        // Pass homeQueries and qTime or use them directly if applicable
        viewController.seasonYear = 2024
        return viewController
    }

    func updateUIViewController(_ uiViewController: FirstResults, context: Context) {
        // Update the view controller if needed, potentially with new homeQueries or qTime values
    }
}
