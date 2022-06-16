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
    

    let driverNumbers = Data.driverNumber
    let driversGivenName = Data.driverFirstNames
    let driverDOB = Data.driverDOB
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        cell.layer.borderColor = UIColor.purple.cgColor
        cell.layer.cornerRadius = 15
        
        if Data.whichQuery == 0 {

            cell.topCellLabel.text = teamNames[indexPath.item]
            cell.bottomCellLabel.text = teamNationality[indexPath.item]
            

        }
        
        if Data.whichQuery == 1 {
            
            cell.topCellLabel.text = "\(driversGivenName[indexPath.item]!) \(driverNames[indexPath.item]!) #\(driverNumbers[indexPath.item]!)"
            cell.bottomCellLabel.text = "Nationality: \(driverNationality[indexPath.item]!)\nBorn: \(driverDOB[indexPath.item]!)"
            
        }
        
        
        
        
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellIndexPath = indexPath.item
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? myCell {
            print("Cell is selected")
            cell.getCellIndexPath(myCell: cell, myCellIP: cellIndexPath)

            
            
            if Data.whichQuery == 0 {
                

                
                performSegue(withIdentifier: "resultsTransition", sender: self)
            }
            
            if Data.whichQuery == 1 {
                
                
                performSegue(withIdentifier: "resultsTransition", sender: self)
            }
            
            
            
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? myCell {
            print("Cell deselected")
            cell.self.isHidden = false
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
        Data.driverFirstNames.removeAll()
        Data.driverDOB.removeAll()
        Data.driverNumber.removeAll()
        print("removed all data points from the arrays holding the cells")
    }
    
    

    
}
