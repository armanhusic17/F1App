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
    
    // The results view controller shows the selected cell's full details - wiki page
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    let resultsModel = ResultsModel()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print("RESULTS HERE")
        cutCorners()
        resultsModel.loadResults(myWebview: webView)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    
    func cutCorners(){
        webView.layer.cornerRadius = 8
    }
    
    
    
    
    
}
