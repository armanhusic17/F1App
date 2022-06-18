//
//  ResultsVC.swift
//  F1App
//
//  Created by Arman Husic on 6/16/22.
//

import Foundation
import UIKit
import WebKit

class ResultsVC: UIViewController {
    
    let teamWikis = Data.teamURL
    let driverWikis = Data.driverURL
    let circuitWikis = Data.circuitURL
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func cutCorners(){
        webView.layer.cornerRadius = 8
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print("RESULTS HERE")
        cutCorners()
        loadResults()
        
    }
    
    
    func loadResults() {
        
        guard let cellPath = Data.cellIndexPassed else {return}
        if Data.whichQuery == 0 {
            guard let teamURL = URL(string: (teamWikis[cellPath])!) else {return}
            webView.load(URLRequest(url: teamURL ))
            
        }
        if Data.whichQuery == 1 {
            guard let driverURL = URL(string: driverWikis[cellPath]!) else {return}
            webView.load(URLRequest(url: driverURL ))

        }
//        if Data.whichQuery == 2 {
//            let circuitURL = URL(string: circuitWikis[cellPath]!)!
//            webView.load(URLRequest(url: circuitURL ))
//
//        }
        
        webView.setNeedsLayout()
        webView.scrollView.contentInsetAdjustmentBehavior = .never

    }
    
    
    
    
}
