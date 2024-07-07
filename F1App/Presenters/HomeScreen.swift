//
//  HomeScreen.swift
//  F1App
//
//  Created by Arman Husic on 2/19/24.
//

import SwiftUI
import UIKit

struct HomeScreen: View {
    @ObservedObject var viewModel = HomeViewModel(seasonYear: "\(Calendar.current.component(.year, from: Date()))")
    @State private var isLoading = true
    var body: some View {
        ZStack {
            backgroundGradient
            content
        }
    }

    @ViewBuilder
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                .black,
                .black,
                .black.opacity(0.95),
                .mint.opacity(0.75),
                .black
            ],
            startPoint: .bottomTrailing,
            endPoint: .topTrailing
        )
            .ignoresSafeArea()
    }

    @ViewBuilder
    private var content: some View {
        VStack {
            HomeTopBar
            QueriesScrollView
        }
    }

    @ViewBuilder
    private var HomeTopBar: some View {
        VStack {
            Text("Box Box F1")
                .font(.headline)
                .bold()
                .foregroundStyle(.white.opacity(0.25))
                .padding([.bottom, .top], 8)
            SeasonSelector(currentSeason: $viewModel.seasonYear) { season in
                viewModel.seasonYear = season
                print(season)
            }
        }
    }

    @ViewBuilder
    private var QueriesScrollView: some View {
        ScrollView {
            QueriesCollection
        }
    }

    @ViewBuilder
    private var QueriesCollection: some View {
        ScrollView(.horizontal) {
            LazyHGrid(
                rows: [GridItem(.fixed(UIScreen.main.bounds.width))],
                spacing: 16
            ) {
                ForEach(viewModel.driverStandings, id: \.self) { driverStanding in 
                    DriversCards(
                        wdcPosition:        "WDC Position: \(driverStanding.position)",
                        wdcPoints:          "Points \(driverStanding.points)",
                        constructorName:    "\(driverStanding.teamNames)",
                        image:              driverStanding.imageUrl,
                        items:              ["\(driverStanding.givenName)\n\(driverStanding.familyName)"],
                        seasonYearSelected: viewModel.seasonYear
                    )
                }
            }
        }

        ScrollView(.horizontal) {
            LazyHGrid(
                rows: [GridItem(.fixed(UIScreen.main.bounds.width))],
                spacing: 16
            ) {
                ForEach(Array(viewModel.constructorStandings.enumerated()), id: \.element) { index,constructorStanding in
                    ConstructorsCards(
                        wccPosition:     "WCC Position: \(constructorStanding.position ?? "⏳")",
                        wccPoints:       "WCC Points: \(constructorStanding.points ?? "⏳")",
                        constructorWins: "Wins: \(constructorStanding.wins ?? "⏳")",
                        image:           viewModel.constructorImages[safe: index] ?? "",
                        items: ["\(constructorStanding.constructor?.name ?? "⏳")"],
                        seasonYearSelected: viewModel.seasonYear
                    )
                }
            }
        }
    } // end queriescollection
}

#Preview {
    HomeScreen()
}
