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
    
    func loadResults(myself: UIViewController) {
        guard let cellPath = Data.cellIndexPassed else { return }
        
        var urlString: String?
        
        if Data.whichQuery == 0 {
            urlString = teamWikis[cellPath]
        } else if Data.whichQuery == 1 {
            urlString = driverWikis[cellPath]
        } else if Data.whichQuery == 2 {
            urlString = raceWiki[cellPath]
        } else {
            print("No results tied to UI yet")
            return
        }
        
        guard var urlString = urlString else { return }
        urlString = urlString.replacingOccurrences(of: "http", with: "https")
        
        guard let url = URL(string: urlString) else { return }
        print(url)
        
        let safariVC = SFSafariViewController(url: url)
        myself.present(safariVC, animated: true, completion: nil)
    }

    

    
}
