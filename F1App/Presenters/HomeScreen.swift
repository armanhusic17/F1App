//
//  HomeScreen.swift
//  F1App
//
//  Created by Arman Husic on 2/19/24.
//

import SwiftUI

struct HomeScreen: View {
    
    let homeModel = HomeModel()
    @State var text: String
    
    
    struct ErgastQueryButton {
        let icon: Image?
        let label: String
        var action: () -> Void
    }
    
    let queries: [ErgastQueryButton] = [
        ErgastQueryButton(icon: Image(systemName: "moon.fill"), label: "Drivers", action: {
            print("Drivers Query")
        }),
        ErgastQueryButton(icon:Image(systemName: "moon.fill"), label: "Constructors", action: {
            print("Constructors Query")
        }),
        ErgastQueryButton(icon: Image(systemName: "moon.fill"), label: "Grand Prix", action: {
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
