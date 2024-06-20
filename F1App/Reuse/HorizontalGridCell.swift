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
    let image: [String]
    let items: [String]
    
    init(
        poles: String,
        wins: String,
        races: String,
        image: [String],
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
                            AsyncImage(url: URL(string: image[0])) { phase in
                               switch phase {
                               case .empty:
                                   Image(systemName: "person.circle")
                                       .resizable()
                                       .aspectRatio(contentMode: .fit)
                                       .font(.caption)
                                       .foregroundStyle(Color.red)
                               case .success(let image):
                                   image
                                       .resizable()
                                       .font(.headline)
                                       .foregroundStyle(Color.white)
                               case .failure:
                                   Image(systemName: "person.circle")
                                       .resizable()
                                       .font(.headline)
                                       .foregroundStyle(Color.white)
                               @unknown default:
                                   EmptyView()
                               }
                           }
                            Text(item.capitalized)
                                .fixedSize(horizontal: true, vertical: false)
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
