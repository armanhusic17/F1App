//
//  myCell.swift
//  F1App
//
//  Created by Arman Husic on 3/27/22.
//

import Foundation
import UIKit

class myCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cellBaseView: UIView!
    @IBOutlet weak var topCellLabel: UILabel!
    @IBOutlet weak var bottomCellLabel: UILabel!
    @IBOutlet weak var bottomCellLabel2: UILabel!
    
    
    var myCellIndexPath:Int?
    
    func getCellIndexPath(myCell:myCell, myCellIP: Int){
        myCellIndexPath = myCellIP
        Data.cellIndexPassed = myCellIndexPath
    }
}
