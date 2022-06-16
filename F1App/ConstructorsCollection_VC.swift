//
//  ConstructorsCollection_VC.swift
//  F1App
//
//  Created by Arman Husic on 4/12/22.
//

import Foundation
import UIKit

class ConstructorsCollection_VC : UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let myData = Data()
    
    let teamNames = Data.teamNames
    let driverNames = Data.driverNames
    
    let teamNationality = Data.teamNationality
    let driverNationality = Data.driverNationality
    
    let teamWikis = Data.teamURL
    let driverWikis = Data.driverURL
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
    }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if Data.whichQuery == 0 {
            return Data.teamNames.count
        }
        
        if Data.whichQuery == 1 {
            return Data.driverNames.count
        }
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let availableWidth = view.frame.width
            let availableHeight = view.frame.height
            
        return CGSize(width: availableWidth * 0.90, height: availableHeight * 0.5)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! myCell
        
        
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.cornerRadius = 15
        
        if Data.whichQuery == 0 {
            let teamURL = URL(string: teamWikis[indexPath.item]!)!

            cell.topCellLabel.text = teamNames[indexPath.item]
            cell.bottomCellLabel.text = teamNationality[indexPath.item]
            cell.webView.load(URLRequest(url: teamURL ))
            

        }
        
        if Data.whichQuery == 1 {
            let driverURL = URL(string: driverWikis[indexPath.item]!)!
            
            cell.topCellLabel.text = driverNames[indexPath.item]
            cell.bottomCellLabel.text = driverNationality[indexPath.item]
            cell.webView.load(URLRequest(url: driverURL ))
            
        }
        
        
        
        cell.cellImage.image = UIImage.checkmark
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? myCell {
            print("Cell is selected")
          
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? myCell {
            print("Cell deselected")
           
        }
    }
    
    

    
}
