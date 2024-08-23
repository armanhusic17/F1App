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
        case carCircleImage = "newAltLogo"
        case WCCLabel = "WCC Champion"
        case wccLabel = "World Constructors' Championship Standings"
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
        scrollView
    }
    
    @MainActor
    @ViewBuilder private var scrollView: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(items, id: \.self) { item in
                    VStack(alignment: .leading) {
                        constructorImage
                        constructorTitle(item: item)
                        constructorDetails
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
                    )
                    .cornerRadius(24)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true) 
    }
    
    @ViewBuilder private var constructorDetails: some View {
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
    
    @ViewBuilder private func constructorTitle(item: String) -> some View {
        Text(item.capitalized)
            .bold()
            .fixedSize(horizontal: true, vertical: false)
            .font(.largeTitle)
            .padding(.top, 16)
        
        Rectangle()
            .foregroundStyle(.white.opacity(0.5))
            .frame(height: 0.5)
            .padding(.bottom, 16)
    }
    
    @MainActor
    @ViewBuilder private var constructorImage: some View {
        ZStack(alignment: .leading) {
            AsyncImage(url: URL(string: image)) { image in
                image
                    .resizable()
                    .renderingMode(.original)
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height/3
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
                if let uiImage = UIImage(named: Constant.carCircleImage.rawValue) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height/3
                        )
                        .foregroundStyle(
                            .black
                        )
                        .scaledToFit()
                        .cornerRadius(24.0)
                }
            }
        }

    }
}

#Preview {
//    HomeScreen()
    ConstructorsCards(
        wccPosition: "WCC Position: 1",
        wccPoints: "WCC Points: 400",
        constructorWins: "Wins: 125",
        image: "",
        items: ["Scuderia\nFerrari"],
        seasonYearSelected: "2024"
    )
}
