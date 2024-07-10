//
//  GrandPrixCards.swift
//  F1App
//
//  Created by Arman Husic on 6/23/24.
//

import SwiftUI

struct GrandPrixCards: View {
    let grandPrixName: String
    let circuitName: String
    let raceDate: String
    let raceTime: String
    let winnerName: String
    let winnerTeam: String
    let winningTime: String
    let fastestLap: String
    let countryFlag: String
    
    init(
        grandPrixName: String,
        circuitName: String,
        raceDate: String,
        raceTime: String,
        winnerName: String,
        winnerTeam: String,
        winningTime: String,
        fastestLap: String,
        countryFlag: String
    ) {
        self.grandPrixName = grandPrixName
        self.circuitName = circuitName
        self.raceDate = raceDate
        self.raceTime = raceTime
        self.winnerName = winnerName
        self.winnerTeam = winnerTeam
        self.winningTime = winningTime
        self.fastestLap = fastestLap
        self.countryFlag = countryFlag
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        if let flag = Locale.flag(for: "\(countryFlag)") {
                            Text(flag)
                                .font(.largeTitle)
                        }
                        Text(grandPrixName)
                    }
                    .font(.largeTitle)

                    Divider()

                    HStack {
                        Image(systemName: "flag.checkered.2.crossed")
                            .foregroundStyle(.white)
                        Text("\(circuitName)")
                            .font(.subheadline)
                    }
                    .font(.headline)

                    HStack {
                        Image(systemName: "calendar.badge.clock")
                            .font(.title)
                            .foregroundStyle(.secondary)
                        Text("Race Date: \(raceDate) at \(raceTime)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Divider()

                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "trophy.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.yellow.opacity(0.5))
                            Text("Race Winner")
                            Text("\(winnerName)")
                                .bold()
                                .font(.title3)
                        }
                        HStack {
                            Image(systemName: "trophy.circle")
                                .font(.largeTitle)
                                .foregroundStyle(.yellow.opacity(0.5))
                            Text("Winning Constructor")
                                .font(.subheadline)
                            Text("\(winnerTeam)")
                                .bold()
                                .font(.subheadline)
                        }
                        HStack {
                            Image(systemName: "stopwatch")
                                .font(.largeTitle)
                                .foregroundStyle(.white.opacity(0.5))
                            Text("Winning Time: \(winningTime)")
                                .font(.caption)
                            Text("Fastest Lap: \(fastestLap)")
                                .font(.caption)
                        }
                    }
                    .padding(.top, 5)
                }
                .foregroundStyle(.white)
                .padding()
                .background(
                    LinearGradient(
                        colors: [
                            .black,
                            .black,
                            .black,
                            .mint.opacity(0.75)
                        ],
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                )
                .cornerRadius(10)
                .shadow(radius: 5)
            }
        }
    }
}

// Preview
struct GrandPrixCards_Previews: PreviewProvider {
    static var previews: some View {
        GrandPrixCards(
            grandPrixName: "Bahrain Grand Prix",
            circuitName: "Bahrain International Circuit, Sakhir",
            raceDate: "2025-03-31",
            raceTime: "13:00:00Z",
            winnerName: "Lewis Hamilton",
            winnerTeam: "Scuderia Ferrari",
            winningTime: "1:30:21.432",
            fastestLap: "1:24.309", 
            countryFlag: "🇧🇭"
        )
    }
}

