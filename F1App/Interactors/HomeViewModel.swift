//
//  HomeViewModel.swift
//  F1App
//
//  Created by Arman Husic on 4/27/24.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var seasonYear: String = "2024"
    @Published var shouldNavigateToFirstResults = false
    let homeModel = HomeModel()

    func queriesArray() -> [ErgastQueryButton] {
        let queries: [ErgastQueryButton] = [
            ErgastQueryButton(
                icon: Image("lewis"),
                label: "Drivers",
                action: {
                F1DataStore.whichQuery = 1
                print("Drivers Query Fires Here")
                F1ApiRoutes.worldDriversChampionshipStandings(seasonYear: self.seasonYear) { Success in
                    DispatchQueue.main.async {
                        if Success {
                            print("Success = \(Success)")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 8.5) {
                                self.shouldNavigateToFirstResults = true
                            }
                        }
                    }
                }
            }),
            ErgastQueryButton(
                icon: Image("f1Car"),
                label: "Constructors",
                action: {
                print("Constructors Query Fires Here")
                F1ApiRoutes.getConstructorStandings(seasonYear: self.seasonYear) { Success in
                    DispatchQueue.main.async {
                        if Success {
                            print("Success = \(Success)")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                self.shouldNavigateToFirstResults = true
                            } 
                        }
                    }
                }
            }),
            ErgastQueryButton(
                icon: Image("circuitLogo"),
                label: "Grand Prix",
                action: {
                print("Grand Prix Query Fires Here")
                F1ApiRoutes.allRaceSchedule(seasonYear: self.seasonYear) { Success in
                    if Success {
                        print("Success = \(Success)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                            self.shouldNavigateToFirstResults = true
                        }
                    }
                }
            })
        ]
        return queries
    }

    private func returnYear() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: Date())) ?? 2024
    }

    private func showResults(qTime: Double) {
        // Simulate loading time
        DispatchQueue.main.asyncAfter(deadline: .now() + qTime) {
            // Navigate to results screen
            print("Query completed successfully.")
        }
    }
}

struct MyViewControllerWrapper: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: FirstResults, context: Context) {
        //
    }
    @MainActor
    func makeUIViewController(context: Context) -> FirstResults {
        FirstResults()
    }
}
