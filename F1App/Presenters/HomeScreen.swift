//
//  HomeScreen.swift
//  F1App
//
//  Created by Arman Husic on 2/19/24.
//

import SwiftUI
import UIKit

struct HomeScreen: View {
    @StateObject internal var myAccountViewModel = MyAccountViewModel()
    @State private var isLoading = true
    @State private var isSheetPresented = false
    @StateObject var viewModel = HomeViewModel(
        networkClient: NetworkClient(),
        seasonYear: "\(Calendar.current.component(.year, from: Date()))"
    )
    
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
                .italic()
                .foregroundStyle(.white.opacity(0.1))
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
                            wdcPosition: viewModel.wdcPosition(driverStanding: driverStanding),
                            wdcPoints: viewModel.wdcPoints(driverStanding: driverStanding),
                            constructorName: viewModel.constructorName(driverStanding: driverStanding),
                            image: viewModel.driverImage(driverStanding: driverStanding),
                            items: viewModel.driverName(driverStanding: driverStanding),
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
                                viewModel.wccPosition(constructorStanding: constructorStanding),
                            wccPoints:  viewModel.wccPoints(constructorStanding: constructorStanding),
                            constructorWins:  viewModel.wccWins(constructorStanding: constructorStanding),
                            image:  viewModel.wccImage(index: index),
                            items:  viewModel.wccName(constructorStanding: constructorStanding),
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
                                    grandPrixName: viewModel.gpName(race: race),
                                    circuitName: viewModel.gpCircuit(race: race),
                                    raceDate: viewModel.gpDate(race: race),
                                    raceTime: viewModel.gpTime(race: race),
                                    winnerName: viewModel.gpWinner(index: index),
                                    winnerTeam: viewModel.gpWinnerTeam(index: index),
                                    winningTime: viewModel.gpWinnerTime(index: index),
                                    fastestLap: viewModel.gpTeamFastestLap(index: index),
                                    countryFlag: viewModel.gpTeamCountryFlag(race: race)
                                )
                            }
                        }
                    }
                }
            }
        }
    }

}

#Preview {
    HomeScreen()
}
