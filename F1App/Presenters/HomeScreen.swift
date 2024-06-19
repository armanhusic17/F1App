//
//  HomeScreen.swift
//  F1App
//
//  Created by Arman Husic on 2/19/24.
//

import SwiftUI
import UIKit

struct HomeScreen: View {
    @ObservedObject var viewModel = HomeViewModel(seasonYear: "2024")
    let homeModel = HomeModel()

    var body: some View {
        ZStack {
            backgroundGradient
            content
        }
        .onAppear {
            Task {
                await viewModel.loadDriverStandings(seasonYear: viewModel.seasonYear)
            }
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
                .font(.title)
                .bold()
                .foregroundStyle(.white)
                .padding([.bottom, .top], 32)
            SeasonSelector(currentSeason: viewModel.seasonYear) { season in
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
                spacing: 15
            ) {
                ForEach(viewModel.driverStandings, id: \.self) { driverStanding in
                    HorizontalGridCell(
                        poles: "WDC: \(driverStanding.position)",
                        wins: "Points \(driverStanding.points)",
                        races: "\(driverStanding.teamNames)",
                        image: driverStanding.imageUrl,
                        items: [" \(driverStanding.givenName) \(driverStanding.familyName)"]
                    )
                }
            }
        }

        ScrollView(.horizontal) {
            LazyHGrid(
                rows: [GridItem(.fixed(UIScreen.main.bounds.width))],
                spacing: 15
            ) {
                ForEach(viewModel.uniqueTeams, id: \.self) { driverStanding in
                    HorizontalGridCell(
                        poles: "WCC: ",
                        wins: "Points ",
                        races: "",
                        image: driverStanding.imageUrl,
                        items: [" \(driverStanding.teamNames)"]
                    )
                }
            }
        }

        ScrollView(.horizontal) {
            LazyHGrid(
                rows: [GridItem(.fixed(UIScreen.main.bounds.width))],
                spacing: 15
            ) {
                ForEach(viewModel.driverStandings, id: \.self) { driverStanding in
                    HorizontalGridCell(
                        poles: "WDC: \(driverStanding.position)",
                        wins: "Points \(driverStanding.points)",
                        races: "\(driverStanding.teamNames)",
                        image: driverStanding.imageUrl,
                        items: [" \(driverStanding.givenName) \(driverStanding.familyName)"]
                    )
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
