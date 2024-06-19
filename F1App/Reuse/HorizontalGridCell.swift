//
//  HorizontalGridCell.swift
//  F1App
//
//  Created by Arman Husic on 5/25/24.
//

import SwiftUI

struct HorizontalGridCell: View {
    let poles: String
    let wins: String
    let races: String
    let image: String
    let items: [String]
    
    init(
        poles: String,
        wins: String,
        races: String,
        image: String,
        items: [String]
    ) {
        self.poles = poles
        self.wins = wins
        self.races = races
        self.image = image
        self.items = items
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(items, id: \.self) { item in
                    VStack {
                        HStack {
                            Image(systemName: image)
                                .font(.largeTitle)
                                .aspectRatio(contentMode: .fit)
                                .ignoresSafeArea()
                            Text(item.capitalized)
                                .bold()
                                .font(.largeTitle)
                            Spacer()
                        }
                        .padding(25)
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(poles)
                                Text(wins)
                                Text(races)
                                Text(poles)
                                Text(wins)
                                Text(races)
                                Text(poles)
                            }
                            .font(.title)
                            .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                       
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            colors: [.black, .clear, .red],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                    )
                    .cornerRadius(12)
                }
            }
        }
    }
}
