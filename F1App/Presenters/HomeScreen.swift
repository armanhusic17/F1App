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
            icon: Image(systemName: "atom"),
            label: "Drivers",
            action: {
                print("Drivers Query")
        }),
        ErgastQueryButton(
            icon:Image(systemName: "camera.aperture"),
            label: "Constructors",
            action: {
                print("Constructors Query")
                F1ApiRoutes.getConstructorStandings(seasonYear: "2024") { Success in
                    print(Success)
                    FirstResultsWrapper()
                }
        }),
        ErgastQueryButton(
            icon: Image(systemName: "kph.circle"),
            label: "Grand Prix",
            action: {
                print("Grand Prix Query")
        })
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red.opacity(0.5), .green, .red.opacity(0.5)], startPoint: .bottom, endPoint: .top).ignoresSafeArea()
            VStack {
                Text("Box Box F1 ")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                Text("Enter Season")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                TextField("", text: $text)
                    .frame(alignment: .center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                ScrollView {
                    VStack {
                        LazyVGrid(
                            columns: [GridItem(.fixed(UIScreen.main.bounds.width / 2))],
                            spacing: 24) {
                                ForEach(queries.indices, id: \.self) { index in
                                    Button(action: queries[index].action) {
                                        VStack {
                                            queries[index].icon?
                                                .resizable()
                                                .scaledToFit()
                                                .padding(.all, 75)
                                            Text(queries[index].label)
                                                .font(.title)
                                                .bold()
                                        } // end hstack button
                                        .frame(width: 500, height: 500, alignment: .center)
                                        .cornerRadius(24)
                                        .foregroundStyle(
                                            LinearGradient(colors: [.indigo, .black], startPoint: .top, endPoint: .bottom)
                                        )
                                        .padding(8)
                                    }
                                    .background(
                                        LinearGradient(
                                            colors: [.blue.opacity(0.1), .yellow.opacity(0.2)],
                                            startPoint: .bottom, endPoint: .trailing
                                        )
                                    )
                                }
                            }
                            .padding(20)
                    }
                }
                .ignoresSafeArea()
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
