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
    let teamWikis = F1DataStore.teamURL
    let driverWikis = F1DataStore.driverURL
    let raceWiki = F1DataStore.circuitURL
    
    func loadResults(myself: UIViewController) {
        guard let cellPath = F1DataStore.cellIndexPassed else { return }
        
        var urlString: String?
        
        if F1DataStore.whichQuery == 0 {
            urlString = teamWikis[safe: cellPath] ?? ""
            print(urlString)
        } else if F1DataStore.whichQuery == 1 {
            urlString = driverWikis[safe: cellPath] ?? ""
            print(urlString)
        } else if F1DataStore.whichQuery == 2 {
            urlString = raceWiki[safe: cellPath] ?? ""
            print(urlString)
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
