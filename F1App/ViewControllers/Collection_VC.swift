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
        
        guard let thisSeason = Data.seasonYearSelected else {return myCell()}
        collectionmodel.cellViewFormat(cell: cell)
        collectionmodel.cellLogic(cell: cell, indexPath: indexPath)

        F1ApiRoutes.getRaceResults(seasonYear: thisSeason, round: indexPath.item)

        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellIndexPath = indexPath.item
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? myCell {
            print("Cell is selected")
            cell.getCellIndexPath(myCell: cell, myCellIP: cellIndexPath)
            performSegue(withIdentifier: "resultsTransition", sender: self)
            
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
