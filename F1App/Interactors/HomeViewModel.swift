//
//  HomeViewModel.swift
//  F1App
//
//  Created by Arman Husic on 4/27/24.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var seasonYear: String = "2024"
    @Published var drivers: [String] = []
    let homeModel = HomeModel()
    
    init(
        seasonYear: String
    ) {
        self.seasonYear = returnYear().description
        self.loadInitialData()
    }

    private func returnYear() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: Date())) ?? 2024
    }
    
    private func loadInitialData() {
        print("Drivers Query Fires Here")
        F1ApiRoutes.worldDriversChampionshipStandings(seasonYear: self.seasonYear) { Success in
            DispatchQueue.main.async {
                if Success {
                    print("Success = \(Success) drivers query - these will all just load on init")
                    
                }
            }
        }
        print("Constructors Query Fires Here")
        F1ApiRoutes.getConstructorStandings(seasonYear: self.seasonYear) { Success in
            DispatchQueue.main.async {
                if Success {
                    print("Success = \(Success) constructors query")
                    
                }
            }
        }
        
        print("Grand Prix Query Fires Here")
        F1ApiRoutes.allRaceSchedule(seasonYear: self.seasonYear) { Success in
            if Success {
                print("Success = \(Success) - grand prix query")
                
            }
        }
    }
    
    

}
