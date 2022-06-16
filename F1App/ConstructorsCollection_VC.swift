//
//  ConstructorsCollection_VC.swift
//  F1App
//
//  Created by Arman Husic on 4/12/22.
//

import Foundation
import UIKit
import WebKit

class ConstructorsCollection_VC : UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let myData = Data()
    
    let teamNames = Data.teamNames
    let driverNames = Data.driverNames
    
    let teamNationality = Data.teamNationality
    let driverNationality = Data.driverNationality
    
    let teamWikis = Data.teamURL
    let driverWikis = Data.driverURL
    let driverNumbers = Data.driverNumber
    let driversGivenName = Data.driverFirstNames
    let driverDOB = Data.driverDOB
    
    @IBOutlet weak var baseResultsView: UIView!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultsView.isHidden = true
    }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if Data.whichQuery == 0 {
            return Data.teamNames.count
        }
        
        if Data.whichQuery == 1 {
            return Data.driverNames.count
        }
        
        return 5
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let availableWidth = view.frame.width
            let availableHeight = view.frame.height
            
        return CGSize(width: availableWidth * 0.85, height: availableHeight * 0.20)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! myCell
        
        
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.cornerRadius = 15
        
        if Data.whichQuery == 0 {

            cell.topCellLabel.text = teamNames[indexPath.item]
            cell.bottomCellLabel.text = teamNationality[indexPath.item]
            

        }
        
        if Data.whichQuery == 1 {
            
            cell.topCellLabel.text = "\(driversGivenName[indexPath.item]!) \(driverNames[indexPath.item]!) #\(driverNumbers[indexPath.item]!)"
            cell.bottomCellLabel.text = "Nationality: \(driverNationality[indexPath.item]!), Born: \(driverDOB[indexPath.item]!)"
            
        }
        
        
        
        
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? myCell {
            print("Cell is selected")
            cell.self.isHidden = true
            if Data.whichQuery == 0 {

                let teamURL = URL(string: teamWikis[indexPath.item]!)!
                webView.load(URLRequest(url: teamURL ))
            }
            if Data.whichQuery == 1 {
                let driverURL = URL(string: driverWikis[indexPath.item]!)!
                webView.load(URLRequest(url: driverURL ))

            }
            
            resultsView.isHidden = false
            
            
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? myCell {
            print("Cell deselected")
            cell.self.isHidden = false
            resultsView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Data.driverNationality.removeAll()
        Data.driverURL.removeAll()
        Data.driverNames.removeAll()
        Data.teamURL.removeAll()
        Data.teamNames.removeAll()
        Data.teamNationality.removeAll()
        print("removed all data points from the arrays holding the cells")
        resultsView.isHidden = true
    }
    
    

    
}
