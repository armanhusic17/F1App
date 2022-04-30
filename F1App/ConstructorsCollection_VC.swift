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
    let names = Data.teamNames
    let nationalities = Data.teamNationality
    let teamWikis = Data.teamURL
    
    var green = UIColor(red: 50.00/255.0, green: 200.0/255.0, blue: 15.00/255.0, alpha: 1.0)
    var red = UIColor(red: 100/255.0, green: 200.0/255.0, blue: 15.00/255.0, alpha: 1.0)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
    }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Data.teamNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let availableWidth = view.frame.width
            let availableHeight = view.frame.height
            
        return CGSize(width: availableWidth * 0.90, height: availableHeight * 0.85)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! myCell
        let url = URL(string: teamWikis[indexPath.item]!)!

        cell.layer.borderWidth = 5
        cell.layer.borderColor = red.cgColor
        cell.layer.cornerRadius = 15
        
        cell.topCellLabel.text = names[indexPath.item]
        cell.bottomCellLabel.text = nationalities[indexPath.item]
        cell.cellImage.image = UIImage.strokedCheckmark
        cell.webView.load(URLRequest(url: url ))
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? myCell {
            print("Cell is selected")
            cell.layer.borderColor = red.cgColor
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? myCell {
            print("Cell deselected")
        }
    }
    
    

    
}
