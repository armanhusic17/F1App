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
    let image: Image
    let items: [String]
    let seasonYearSelected: String

    private enum Constant: String {
        case trophyImage = "trophy.circle"
        case trophyFillImage = "flag.checkered.circle.fill"
        case checkeredFlag = "flag.checkered.circle"
        case carCircleImage = "gridPulseRed_1024"
        case WCCLabel = "WCC Champion"
        case wccLabel = "World Constructors' Championship Standings"
    }
    
    init(
        wccPosition: String,
        wccPoints: String,
        constructorWins: String,
        image: Image,
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
                            .padding()
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background(
                        TimelineView(.animation) { timeline in
                            let x = (cos(timeline.date.timeIntervalSince1970) + 1.5) / 3

                            if #available(iOS 18.0, *) {
                                MeshGradient(width: 3, height: 3, points: [
                                    [0, 0], [Float(x), 0], [1, 0],
                                    [0, 0.75], [Float(x), 0.5], [1, Float(x)],
                                    [0, 1], [0.95, 1], [1, 1]
                                ], colors: [
                                    .black, .black, .black,
                                    .black, .gray.opacity(0.15), .black,
                                    .black, .black, .black
                                ])
                            } else {
                                // Fallback on earlier versions
                                LinearGradient(
                                    colors: [
                                        .black,
                                        .red,
                                        .black
                                    ],
                                    startPoint: .bottomLeading,
                                    endPoint: .topTrailing
                                )
                            }
                        }
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
                    Image(systemName: Constant.trophyFillImage.rawValue)
                        .aspectRatio(contentMode: .fit)

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
            .font(.largeTitle)
            .padding(.top, 16)
            .frame(maxWidth: .infinity, alignment: .center)

        Rectangle()
            .foregroundStyle(.yellow.opacity(0.5))
            .frame(height: 0.5)
            .padding(.bottom, 16)
    }

    @MainActor
    @ViewBuilder private var constructorImage: some View {
        ZStack(alignment: .leading) {
            image
                .resizable()
                .renderingMode(.original)
                .frame(
                    width: UIScreen.main.bounds.width - 44,
                    height: UIScreen.main.bounds.height/3
                )
                .foregroundStyle(.black.opacity(0.75))
                .background(.white.opacity(0.85))
                .overlay(
                    Rectangle()
                        .stroke(
                            .black
                        )
                )
                .cornerRadius(24)
        }
    }
}

#Preview {
    ConstructorsCards(
        wccPosition: "1",
        wccPoints: "500",
        constructorWins: "Lewis Hamilton",
        image: Image("gridPulseRed_1024"),
        items: ["Ferrari"],
        seasonYearSelected: "2025"
    )
}
