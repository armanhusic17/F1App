//
//  ResultsModel.swift
//  F1App
//
//  Created by Arman Husic on 6/22/22.
//

import Foundation
import WebKit

struct ResultsModel {
    // fields
    
    let teamWikis = Data.teamURL
    let driverWikis = Data.driverURL
    let raceWiki = Data.raceURL
    
    func loadResults(myWebview:WKWebView) {
        
        guard let cellPath = Data.cellIndexPassed else {return}
        if Data.whichQuery == 0 {
            guard let teamURL = URL(string: (teamWikis[cellPath])!) else {return}
            myWebview.load(URLRequest(url: teamURL ))
            
        }
        if Data.whichQuery == 1 {
            guard let driverURL = URL(string: driverWikis[cellPath]!) else {return}
            myWebview.load(URLRequest(url: driverURL ))

        }
        if Data.whichQuery == 2 {
            
            guard let raceURL = URL(string: raceWiki[cellPath]!) else {return}
            
            myWebview.load(URLRequest(url: raceURL ))

        }
        
        myWebview.setNeedsLayout()
        myWebview.scrollView.contentInsetAdjustmentBehavior = .never

    }
    
    
}
