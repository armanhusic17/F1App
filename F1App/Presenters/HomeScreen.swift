//
//  HomeScreen.swift
//  F1App
//
//  Created by Arman Husic on 2/19/24.
//

import SwiftUI
import UIKit

struct HomeScreen: View {
    @ObservedObject var viewModel = HomeViewModel(
        networkClient: NetworkClient(), 
        seasonYear: "\(Calendar.current.component(.year, from: Date()))"
    )
    @StateObject internal var myAccountViewModel = MyAccountViewModel()
    @State private var isLoading = true
    @State private var isSheetPresented = false

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                content
            }
        }
        .tint(.white)
    }

    @ViewBuilder private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                .black,
                .red,
                .black
            ],
            startPoint: .bottomTrailing,
            endPoint: .topTrailing
        )
        .ignoresSafeArea()
    }

    @ViewBuilder private var content: some View {
        VStack {
            HomeTopBar
            QueriesScrollView
        }
    }

    @ViewBuilder private var HomeTopBar: some View {
        VStack {
            Text(HomeViewModel.Constant.homescreenTitle.rawValue)
                .font(.headline)
                .bold()
                .foregroundStyle(.white.opacity(0.10))
                .padding()

            SeasonSelector(currentSeason: $viewModel.seasonYear) { season in
                viewModel.seasonYear = season
            }
        }
        .padding(.bottom)
    }

    @ViewBuilder private var QueriesScrollView: some View {
        ScrollView {
            QueriesCollection
            SettingsButton
        }
    }

    @ViewBuilder private var SettingsButton: some View {
        Button(action: {
            isSheetPresented.toggle()
        }) {
            Text("⛭")
                .foregroundColor(.gray.opacity(0.5))
                .font(.title)
                .padding()
                .background(.clear)
                .cornerRadius(8)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        }
        .sheet(isPresented: $isSheetPresented) {
            MyAccount(viewModel: myAccountViewModel)
                .presentationDetents([.height(100)])
        }
    }

    @ViewBuilder private var collectionTitle: some View {
        HStack {
            Text(HomeViewModel.Constant.wdcLabel.rawValue)
                .bold()
                .foregroundStyle(.white.opacity(0.5))
                .font(.headline)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 8)
    }

    @ViewBuilder private var QueriesCollection: some View {
        driversCollection
        constructorsCollection
        racesCollection
    }
    
    @ViewBuilder private var driversCollection: some View {
        ScrollView(.horizontal) {
            if viewModel.isLoadingDrivers {
                CustomProgressView()
                    .frame(height: 250, alignment: .center)
            } else {
                LazyHGrid(
                    rows: [GridItem(.fixed(UIScreen.main.bounds.width))],
                    spacing: 16
                ) {
                    ForEach(viewModel.driverStandings, id: \.self) { driverStanding in
                        DriversCards(
                            wdcPosition: "WDC Position: \(driverStanding.position)",
                            wdcPoints: "Points \(driverStanding.points)",
                            constructorName: "\(driverStanding.teamNames)",
                            image: driverStanding.imageUrl,
                            items: ["\(driverStanding.givenName)\n\(driverStanding.familyName)"],
                            seasonYearSelected: viewModel.seasonYear
                        )
                    }
                }
            }
        }
    }
    
    @ViewBuilder private var constructorsCollection: some View {
        ScrollView(.horizontal) {
            if viewModel.isLoadingConstructors {
                CustomProgressView()
                    .frame(height: 250, alignment: .center)
            } else {
                LazyHGrid(
                    rows: [GridItem(.fixed(UIScreen.main.bounds.width))],
                    spacing: 16
                ) {
                    ForEach(Array(viewModel.constructorStandings.enumerated()), id: \.element) { index,constructorStanding in
                        ConstructorsCards(
                            wccPosition:
                                "WCC Position: \(constructorStanding.position ?? "⏳")",
                            wccPoints: "WCC Points: \(constructorStanding.points ?? "⏳")",
                            constructorWins: "Wins: \(constructorStanding.wins ?? "⏳")",
                            image: viewModel.constructorImages[safe: index] ?? "",
                            items: ["\(constructorStanding.constructor?.name ?? "⏳")"],
                            seasonYearSelected: viewModel.seasonYear
                        )
                    }
                }
            }
        }
    }
    
    @ViewBuilder private var racesCollection: some View {
        ScrollView(.horizontal) {
            if viewModel.isLoadingGrandPrix {
                CustomProgressView()
                    .frame(height: 250, alignment: .center)
            } else {
                LazyHGrid(
                    rows: [GridItem(.fixed(UIScreen.main.bounds.width))],
                    spacing: 16
                ) {
                    ForEach(Array(viewModel.races.enumerated()), id: \.element.raceName) { index, race in
                        if let resultsViewModel = viewModel.raceResultViewModel {
                            NavigationLink(
                                destination: RaceResultCards(
                                    viewModel: viewModel,
                                    resultsViewModel: resultsViewModel,
                                    race: race
                                )
                                .onAppear {
                                    Task {
                                        await viewModel.fetchRaceResults(
                                            season: viewModel.seasonYear,
                                            round: "\(index + 1)"
                                        )
                                    }
                                }
                            ) {
                                GrandPrixCards(
                                    grandPrixName: "\(race.raceName ?? "⏳")",
                                    circuitName: "\(race.circuit?.circuitName ?? "⏳")",
                                    raceDate: "\(race.date ?? "⏳")",
                                    raceTime: "\(race.time ?? "⏳")",
                                    winnerName: viewModel.raceWinner[safe: index] ?? "⏳",
                                    winnerTeam: viewModel.winningConstructor[safe: index] ?? "⏳",
                                    winningTime: viewModel.winningTime[safe: index] ?? "⏳",
                                    fastestLap: viewModel.winnerFastestLap[safe: index] ?? "⏳",
                                    countryFlag: "\(race.circuit?.location?.country ?? "⏳")"
                                )
                            }
                        }
                    } // end for
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
