//
//  ConstructorsCollection_VC.swift
//  F1App
//
//  Created by Arman Husic on 4/12/22.
//

import Foundation
import UIKit
import WebKit
import MapKit

class Collection_VC : UICollectionViewController, UICollectionViewDelegateFlowLayout, MKMapViewDelegate {

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
        let queryWidth:CGFloat?
        let queryHeight:CGFloat?
        
        if Data.whichQuery == 0 {
            queryWidth = availableWidth * 0.92
            queryHeight = availableHeight * 0.23
            return CGSize(width: queryWidth!, height: queryHeight!)
        } else if Data.whichQuery == 1 {
            queryWidth = availableWidth * 0.92
            queryHeight = availableHeight * 0.25
            return CGSize(width: queryWidth!, height: queryHeight!)
        } else if Data.whichQuery == 2 {
            queryWidth = availableWidth * 0.95
            queryHeight = availableHeight * 0.60
            return CGSize(width: queryWidth!, height: queryHeight!)
        }
        
        return CGSize(width: availableWidth * 0.95, height: availableHeight * 0.33)
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! myCell
        
        cell.F1MapView.delegate = self
        
    
        collectionmodel.cellViewFormat(cell: cell)
        collectionmodel.cellLogic(cell: cell, indexPath: indexPath, mapView: cell.F1MapView)

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


