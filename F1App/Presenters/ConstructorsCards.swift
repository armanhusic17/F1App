//
//  ConstructorsCards.swift
//  F1App
//
//  Created by Arman Husic on 6/23/24.
//


import SwiftUI

struct ConstructorsCards: View {
    let wccPosition: String
    let wccPoints: String
    let constructorWins: String
    let image: String
    let items: [String]
    let seasonYearSelected: String

    private enum Constant: String {
        case trophyImage = "trophy.circle"
        case checkeredFlag = "flag.checkered.circle"
        case carCircleImage = "car.circle"
        case WCCLabel = "WCC Champion"
    }
    
    init(
        wccPosition: String,
        wccPoints: String,
        constructorWins: String,
        image: String,
        items: [String],
        seasonYearSelected: String
    ) {
        self.wccPosition = wccPosition
        self.wccPoints = wccPoints
        self.constructorWins = constructorWins
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
                                    .scaledToFit()
                                    .frame(width: 150, height: 200)
                                    .background(Color.white)
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
                                Image(systemName: "car.circle")
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
                                    Image(systemName: Constant.trophyImage.rawValue)
                                    if wccPosition.range(of: #"\b1\b"#, options: .regularExpression) != nil &&
                                        Int(seasonYearSelected) != Calendar.current.component(.year, from: Date()) {
                                        Text("\(seasonYearSelected) " + Constant.WCCLabel.rawValue)
                                    } else {
                                        Text(wccPosition)
                                    }
                                }
                                HStack {
                                    Image(systemName: Constant.checkeredFlag.rawValue)
                                    Text(wccPoints)
                                }
                                HStack {
                                    Image(systemName: Constant.carCircleImage.rawValue)
                                    Text(constructorWins)
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
                        .cornerRadius(40)
                    )
                }
            }
        }
    }
}

#Preview {
    ConstructorsCards(
        wccPosition: "WCC Position: 1",
        wccPoints: "WCC Points: 400",
        constructorWins: "Wins: 125",
        image: "",
        items: ["Scuderia\nFerrari"],
        seasonYearSelected: "2024"
    )
}
