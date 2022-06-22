//
//  ConstructorsCollection_VC.swift
//  F1App
//
//  Created by Arman Husic on 4/12/22.
//

import Foundation
import UIKit
import WebKit

class Collection_VC : UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let collectionmodel = CollectionModel()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionmodel.howManyCells()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let availableWidth = view.frame.width
            let availableHeight = view.frame.height
            
        return CGSize(width: availableWidth * 0.85, height: availableHeight * 0.25)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! myCell
        
        
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.purple.cgColor
        cell.layer.cornerRadius = 15
        cell.cellImage.layer.cornerRadius = 8
        
        if Data.whichQuery == 0 {

            cell.topCellLabel.text = collectionmodel.teamNames[indexPath.item]
            cell.bottomCellLabel.text = collectionmodel.teamNationality[indexPath.item]
            cell.bottomCellLabel2.text = collectionmodel.constructorID[indexPath.item]

        }
        
        if Data.whichQuery == 1 {
            
            cell.topCellLabel.text = "\(collectionmodel.driversGivenName[indexPath.item]!) \(collectionmodel.driverNames[indexPath.item]!) #\(collectionmodel.driverNumbers[indexPath.item]!)"
            cell.bottomCellLabel.text = "Nationality: \(collectionmodel.driverNationality[indexPath.item]!)\nBorn: \(collectionmodel.driverDOB[indexPath.item]!)"
            cell.bottomCellLabel2.text = collectionmodel.driverCode[indexPath.item]
        }
        
        if Data.whichQuery == 2 {
            cell.topCellLabel.text = collectionmodel.circuitName[indexPath.item]
            cell.bottomCellLabel.text = collectionmodel.circuitLocation[indexPath.item]
            cell.bottomCellLabel2.text = collectionmodel.circuitId[indexPath.item]?.uppercased()
        
        }
        
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellIndexPath = indexPath.item
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? myCell {
            print("Cell is selected")
            cell.getCellIndexPath(myCell: cell, myCellIP: cellIndexPath)
            if Data.whichQuery != 2 {
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
            collectionmodel.removeAllCellData()
    }
    
    

    
}
