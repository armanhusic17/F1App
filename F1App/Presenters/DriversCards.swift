//
//  HorizontalGridCell.swift
//  F1App
//
//  Created by Arman Husic on 5/25/24.
//

import SwiftUI

struct DriversCards: View {
    let wdcPosition: String
    let wdcPoints: String
    let constructorName: String
    let image: String
    let items: [String]
    let seasonYearSelected: String
    
    init(
        wdcPosition: String,
        wdcPoints: String,
        constructorName: String,
        image: String,
        items: [String],
        seasonYearSelected: String
    ) {
        self.wdcPosition = wdcPosition
        self.wdcPoints = wdcPoints
        self.constructorName = constructorName
        self.image = image
        self.items = items
        self.seasonYearSelected = seasonYearSelected
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(items, id: \.self) { item in
                    VStack(alignment: .leading) {
                        HStack {
                            AsyncImage(url: URL(string: image)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 200)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [ 
                                                        .mint,
                                                        .mint,
                                                        .black,
                                                        .black
                                                    ],
                                                    startPoint: .bottomLeading,
                                                    endPoint: .topTrailing
                                                ),
                                                lineWidth: 4
                                            )
                                    )
                            } placeholder: {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 200)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [ 
                                                .mint,
                                                .mint.opacity(0.5),
                                                .mint.opacity(0.4),
                                                .black
                                            ],
                                            startPoint: .bottomLeading,
                                            endPoint: .topTrailing
                                        )
                                    )
                            }

                            Text(item.capitalized)
                                .bold()
                                .fixedSize(horizontal: true, vertical: false)
                                .font(.largeTitle)

                            Spacer()
                        }

                        HStack {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "trophy.circle")
                                    if wdcPosition.contains("1") && Int(seasonYearSelected) !=  Calendar.current.component(.year, from: Date()) {
                                      Text("\(seasonYearSelected) WDC Champion")
                                    } else {
                                        Text(wdcPosition)
                                    }
                                }
                                HStack {
                                    Image(systemName: "flag.checkered.circle")
                                    Text(wdcPoints)
                                }
                                HStack {
                                    Image(systemName: "car.circle")
                                    Text(constructorName)
                                }
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
                            colors: [
                                .black, 
                                .black,
                                .mint
                            ],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                        .cornerRadius(4)
                    )
                }
            }
        }
    }
}

#Preview {
    DriversCards(
        wdcPosition: "WDC Position",
        wdcPoints: "WDC Points",
        constructorName: "Team Name",
        image: "Image",
        items: ["Driver Name"],
        seasonYearSelected: "2024"
    )
}
