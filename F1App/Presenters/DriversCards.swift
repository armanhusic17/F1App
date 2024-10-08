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
        case trophyImage = "trophy.circle.fill"
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
       scrollView
            .padding(.bottom, 25)
    }
    
    @ViewBuilder private func content(item: String) -> some View {
        VStack {
            driverDemographics(item: item)
            lineBelowImage
            driverStats
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder private var scrollView: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(items, id: \.self) { item in
                    VStack(alignment: .leading) {
                        content(item: item)
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            colors: [
                                .red,
                                .black,
                                .black
                            ],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                        .border(Color.black, width: 0.25)
                        .cornerRadius(24)
                    )
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true) 
    }
    
    @ViewBuilder private var lineBelowImage: some View {
        // Line Below image
        Rectangle()
            .foregroundStyle(.yellow.opacity(0.5))
            .frame(height: 0.5)
            .padding(.bottom, 16)
    }

    @ViewBuilder private func driverDemographics(item: String) -> some View {
        // Driver Image and Name
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
                                        .red,
                                        .black,
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
                                .black,
                                .red.opacity(0.5),
                                .black
                            ],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    )
            }

            Text(item.capitalized)
                .bold()
                .fixedSize(horizontal: true, vertical: false)
                .font(.largeTitle)

            Spacer()
        }
    }
    
    @ViewBuilder private var driverStats: some View {
        // Driver Stats
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
                .padding(.bottom)
            }
            .font(.title)
            .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
}

#Preview {
    DriversCards(
        wdcPosition: "",
        wdcPoints: "",
        constructorName: "",
        image: "",
        items: ["", ""],
        seasonYearSelected: ""
    )
}
