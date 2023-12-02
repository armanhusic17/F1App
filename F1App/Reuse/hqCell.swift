//
//  homeCell.swift
//  F1App
//
//  Created by Arman Husic on 7/14/22.
//

import Foundation
import UIKit


class hqCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?
    @IBOutlet weak var homeBaseView: UIView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var enterF1SeasonYear: UITextView!
    @IBOutlet weak var homeCellImageView: UIImageView!
    @IBOutlet weak var cellActivitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        delegate?.menuButtonPressed(cell: self)
    }
    
}

protocol CollectionViewCellDelegate: AnyObject {
    func menuButtonPressed(cell: UICollectionViewCell)
}
