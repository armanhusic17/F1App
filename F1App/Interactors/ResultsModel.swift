//
//  ResultsModel.swift
//  F1App
//
//  Created by Arman Husic on 6/22/22.
//

import Foundation
import SafariServices

struct ResultsModel {
    // fields
    let teamWikis = Data.teamURL
    let driverWikis = Data.driverURL
    let raceWiki = Data.circuitURL
    
    func loadResults(myself:UIViewController) {
        
        guard let cellPath = Data.cellIndexPassed else {return}
        if Data.whichQuery == 0 {
            guard let teamURL = URL(string: (teamWikis[cellPath]) ?? "") else {return}
            let safariVC = SFSafariViewController(url: teamURL)
            myself.present(safariVC, animated: true, completion: nil)
        }
        if Data.whichQuery == 1 {
            guard let driverURL = URL(string: driverWikis[cellPath] ?? "") else {return}
            let safariVC = SFSafariViewController(url: driverURL)
            myself.present(safariVC, animated: true, completion: nil)
        }
        if Data.whichQuery == 2 {
            guard let raceURL = URL(string: raceWiki[cellPath] ?? "") else {return}
            let safariVC = SFSafariViewController(url: raceURL)
            myself.present(safariVC, animated: true, completion: nil)
        } else {
            print("No results tied to ui yet")
        }

        
    }
    

    
}
