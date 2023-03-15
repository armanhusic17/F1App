//
//  ResultsVC.swift
//  F1App
//
//  Created by Arman Husic on 6/16/22.
//
import Foundation
import UIKit
import SafariServices

class ResultsVC: UIViewController {
    
    // The results view controller shows the selected cell's full details - wiki page
    
    @IBOutlet weak var baseView: UIView!
    
    let resultsModel = ResultsModel()
    let F1api = F1ApiRoutes()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RESULTS HERE")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resultsModel.loadResults(myself: self)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    
    
    
}
