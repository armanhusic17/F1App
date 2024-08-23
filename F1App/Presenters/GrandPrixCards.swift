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
    
    private enum Constant: String {
        case circuitFlag = "flag.checkered.2.crossed"
        case calendarImage = "calendar.badge.clock"
        case driverTrophyImage = "trophy.fill"
        case raceWinnerLabel = "Race Winner"
        case winningConstructorTrophyImage = "trophy.circle"
        case winningConstructorLabel = "Winning Constructor"
        case stopWatchImage = "stopwatch"
        case winningTotalTime = "Winning Time:"
        case fastestLap = "Fastest Lap:"
    }
    
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
        scrollView
    }
    
    @ViewBuilder private var scrollView: some View {
        ScrollView(.horizontal) {
            content
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder private var content: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                grandPrixTitle
                Divider()
                circuitNameAndIcon
                raceDateAndIcon
                raceStats
            }
            .foregroundStyle(.white)
            .padding([.horizontal, .top], 16)
            .background(
                .black
            )
            .shadow(radius: 5)
            .cornerRadius(24)

        }
    }
    
    @ViewBuilder private var raceStats: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: Constant.driverTrophyImage.rawValue)
                    .font(.largeTitle)
                    .foregroundStyle(.yellow.opacity(0.5))
                Text(Constant.raceWinnerLabel.rawValue)
                Text("\(winnerName)")
                    .bold()
                    .font(.title3)
            }
            HStack {
                Image(systemName: Constant.winningConstructorTrophyImage.rawValue)
                    .font(.largeTitle)
                    .foregroundStyle(.yellow.opacity(0.5))
                Text(Constant.winningConstructorLabel.rawValue)
                    .font(.subheadline)
                Text("\(winnerTeam)")
                    .bold()
                    .font(.subheadline)
            }
            HStack {
                Image(systemName: Constant.stopWatchImage.rawValue)
                    .font(.largeTitle)
                    .foregroundStyle(.white.opacity(0.5))
                Text(Constant.winningTotalTime.rawValue + " \(winningTime)")
                    .font(.caption)
                Text(Constant.fastestLap.rawValue + " \(fastestLap)")
                    .font(.caption)
            }
        }
        .padding([.top, .bottom], 5)
    }
    
    @ViewBuilder private var raceDateAndIcon: some View {
        HStack {
            Image(systemName: Constant.calendarImage.rawValue )
                .font(.title)
                .foregroundStyle(.secondary)
            Text("Race Date:" + " \(raceDate) at \(raceTime)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.bottom)
    }
    
    @ViewBuilder private var circuitNameAndIcon: some View {
        HStack {
            Image(systemName: Constant.circuitFlag.rawValue)
                .foregroundStyle(.white)
            Text("\(circuitName)")
                .font(.subheadline)
        }
        .font(.headline)
    }
    
    @ViewBuilder private var grandPrixTitle: some View {
        HStack {
            if let flag = Locale.flag(for: "\(countryFlag)") {
                Text(flag)
                    .font(.largeTitle)
            }
            Text(grandPrixName)
        }
        .padding([.top, .bottom])
        .font(.largeTitle)
    }
}

// Preview
struct GrandPrixCards_Previews: PreviewProvider {
    static var previews: some View {
//        HomeScreen()
        GrandPrixCards(grandPrixName: "Dutch Grand Prix",
                       circuitName: "Zandvoort",
                       raceDate: "12/22/1989",
                       raceTime: "1pm",
                       winnerName: "Lewis Hamilton",
                       winnerTeam: "Mereceds AMG Petronas F1",
                       winningTime: "1Hr 2min",
                       fastestLap: "42",
                       countryFlag: "🇧🇦"
        )
    }
}

