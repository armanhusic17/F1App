//
//  RaceResultCards.swift
//  F1App
//
//  Created by Arman Husic on 10/11/24.
//

import SwiftUI

struct RaceResultCards: View {
    var title: String
    var titleImg: String
    var result: [String]
    var rowIcon: String
    
    var body: some View {
        titleCard(
            title: title,
            titleImg: titleImg
        )

        raceResultsList(
            result: result,
            rowIcon: rowIcon
        )
    }
    
    @MainActor func titleCard(title: String, titleImg: String) -> some View {
        HStack {
            VStack {
                ZStack {
                    Circle()
                        .foregroundStyle(.black.opacity(0.4))
                        .frame(width: 100, height: 100)
                        .padding()
                    Image(systemName: titleImg)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .foregroundStyle(.white.opacity(0.5))
                }
                Text(title)
                    .font(.headline)
                    .padding([.bottom], 20)
                    .padding(.horizontal, 8)
            }
            .frame(width: .infinity, height: .infinity, alignment: .center)
            .foregroundStyle(.white)

            ZStack {
                Rectangle()
                    .frame(width: .infinity, height: 100)
                    .ignoresSafeArea()
                    .foregroundStyle(.clear)
                
            }
        }
        .background(
            LinearGradient(colors: [.black.opacity(0.9), .red.opacity(0.9), .yellow], startPoint: .bottomLeading, endPoint: .topTrailing)
        )
        .cornerRadius(12)
        .padding([.top, .bottom, .horizontal], 2)
    }
    
    @MainActor func raceResultsList(result: [String], rowIcon: String) -> some View {
        List {
            ForEach(0..<10) { index in
                HStack {
                    HStack {
                        Text("P\(index + 1)")
                            .bold()
                            .font(.caption)
                        Image(systemName: rowIcon)
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .trailing)
                            .scaledToFit()
                            .padding(.trailing, 0)
                        Text("\(result[index])")
                            .font(.title3)
                    }
                    .foregroundStyle(.white)

                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(
                LinearGradient(colors: [.black.opacity(0.75), .red, .yellow], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(12)
        }
    }
}

#Preview {
    RaceResultCards(
        title: "Monaco Grand Prix Race Results",
        titleImg: "car.fill",
        result: [
            "Hamilton",
            "Vettel",
            "Leclerc",
            "Bottas",
            "Sainz",
            "Piastri",
            "Norris",
            "Perez",
            "Verstappen",
            "Alonso"
        ],
        rowIcon: "person.circle.fill"
    )
}
