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

    private enum Constant: String {
        case personIcon = "person.circle"
        case trophyImage = "trophy.circle"
        case checkeredFlag = "flag.checkered.circle"
        case carCircleImage = "car.circle"
        case WDCLabel = "WDC Champion"
    }

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
                                Image(systemName: Constant.personIcon.rawValue)
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
                                    if wdcPosition.range(of: #"\b1\b"#, options: .regularExpression) != nil &&
                                        Int(seasonYearSelected) != Calendar.current.component(.year, from: Date()) {
                                        Text("\(seasonYearSelected) " + Constant.WDCLabel.rawValue)
                                    } else {
                                        Text(wdcPosition)
                                    }
                                }
                                HStack {
                                    Image(systemName: Constant.checkeredFlag.rawValue)
                                    Text(wdcPoints)
                                }
                                HStack {
                                    Image(systemName: Constant.carCircleImage.rawValue)
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
                        .cornerRadius(40)
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
