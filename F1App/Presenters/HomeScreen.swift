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
    }

    @ViewBuilder
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                .black,
                .red,
                .red.opacity(0.95),
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
        .ignoresSafeArea()
    }

    @ViewBuilder
    private var QueriesCollection: some View {
        VStack {
            LazyVGrid(
                columns: [GridItem(.fixed(UIScreen.main.bounds.width / 2))],
                spacing: 10) {
                    Group {
                        HorizontalGridCell(items: ["1", "2", "3", "4", "5", "6", "7", "8"])
                        HorizontalGridCell(items: ["1", "2", "3", "4", "5", "6", "7", "8"])
                        HorizontalGridCell(items: ["1", "2", "3", "4", "5", "6", "7", "8"])
                    }
                    .frame(width: UIScreen.main.bounds.width)
                }
        }
    }
}

#Preview {
    HomeScreen()
}
