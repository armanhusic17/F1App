//
//  RaceResultCards.swift
//  F1App
//
//  Created by Arman Husic on 10/11/24.
//

import SwiftUI

struct RaceResultCards: View {
    enum Constants {
        static let titleImg: String = "car"
        static let rowIcon: String = "person.circle.fill"
        static let fallbackTitle: String = "Grand Prix Results"
    }
    
    @ObservedObject var viewModel: HomeViewModel
    let race: Race
    
    var body: some View {
        VStack(spacing: 0) {
            titleCard(
                title: race.raceName ?? Constants.fallbackTitle,
                titleImg: Constants.titleImg
            )
            .background(.black)
            .cornerRadius(12)

            raceResultsList(
                results: viewModel.raceResults2,
                rowIcon: Constants.rowIcon
            )
        }
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
                    .frame(width: UIScreen.main.bounds.width, alignment: .center)
                    .font(.title)
                    .bold()
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
            LinearGradient(colors: [.black.opacity(0.9), .red.opacity(0.9), .yellow.opacity(0.75)], startPoint: .bottomLeading, endPoint: .topTrailing)
        )
        .padding([.top, .bottom, .horizontal], 2)
    }
    
    @MainActor func raceResultsList(results: [Result], rowIcon: String) -> some View {
        List {
            ForEach(results.indices, id: \.self) { index in
                let result = results[index]
                HStack {
                    HStack {
                        Text("P\(results[index].position ?? "\(index + 1)")")
                            .bold()
                            .font(.caption)
                        Image(systemName: rowIcon)
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .trailing)
                            .scaledToFit()
                            .padding(.trailing, 0)
                        Text("\(result.driver?.familyName ?? "")")
                            .font(.title3)
                    }
                    .foregroundStyle(.white)

                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(
                LinearGradient(colors: [.black.opacity(0.75), .red, .yellow.opacity(0.75)], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(12)
        }
        .foregroundStyle(.black)
    }
}

#Preview {
    HomeScreen()
}
