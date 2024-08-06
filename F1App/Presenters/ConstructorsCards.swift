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
        case checkeredFlag = "flag.checkered.circle.fill"
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
                        ZStack(alignment: .leading) {
                            AsyncImage(url: URL(string: image)) { image in
                                image
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(
                                        width: 350,
                                        height: 200
                                    )
                                    .background(self.randomTyreColor())
                                    .overlay(
                                        Rectangle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [ .black, .black, .black, .black ],
                                                    startPoint: .bottomLeading,
                                                    endPoint: .topTrailing
                                                )
                                            )
                                    )
                                    .cornerRadius(24)
                            }
                            placeholder: {
                                Image(systemName: Constant.carCircleImage.rawValue)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(
                                        width: 350,
                                        height: 200
                                    )
                                    .foregroundStyle(
                                        .black
                                    )
                                }
                        }

                        Text(item.capitalized)
                            .bold()
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.largeTitle)
                            .padding(.top, 16)
                        
                        Rectangle()
                            .foregroundStyle(.white.opacity(0.5))
                            .frame(height: 0.5)
                            .padding(.bottom, 16)

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

                        }
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            colors: [
                                .black,
                                .red,
                                .black
                            ],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                        .cornerRadius(24)
                    )
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height - 100)
    }
}

#Preview {
    HomeScreen()
//    ConstructorsCards(
//        wccPosition: "WCC Position: 1",
//        wccPoints: "WCC Points: 400",
//        constructorWins: "Wins: 125",
//        image: "",
//        items: ["Scuderia\nFerrari"],
//        seasonYearSelected: "2024"
//    )
}
