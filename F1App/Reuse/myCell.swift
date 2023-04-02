//
//  myCell.swift
//  F1App
//
//  Created by Arman Husic on 3/27/22.
//

import Foundation
import UIKit
import MapKit

class myCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cellBaseView: UIView!
    @IBOutlet weak var topCellLabel: UILabel!
    @IBOutlet weak var bottomCellLabel: UILabel!
    @IBOutlet weak var bottomCellLabel2: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var F1MapView: MKMapView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    
    var myCellIndexPath:Int?
    
    func getCellIndexPath(myCell:myCell, myCellIP: Int){
        myCellIndexPath = myCellIP
        Data.cellIndexPassed = myCellIndexPath
    }
    
   
    
    
}
