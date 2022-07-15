//
//  homeCollection.swift
//  F1App
//
//  Created by Arman Husic on 7/14/22.
//

import Foundation
import UIKit

class homeCollection: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    let f1routes = F1ApiRoutes()
    var homeModel = HomeModel()
    let collectionModel = CollectionModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        navigationController?.delegate = self

        
    }
    
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            print("Showing self now")


        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        if indexPath.item == 0 {
            return CGSize(width: view.frame.width * 0.99, height: view.frame.height * 0.20)

        }
        return CGSize(width: CGFloat((collectionView.frame.size.width / 2) - 1), height: view.frame.height * 0.20)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myHomeCell", for: indexPath) as! myHomeCell
        
        if indexPath.item == 0 {
            cell.bottomLabel.text = "Enter F1 Season"
            cell.topLabel.text = ""
            cell.layer.borderWidth = 8
            cell.layer.borderColor = UIColor.black.cgColor
            cell.enterYear.isHidden = false
        }
        if indexPath.item == 1 {
            cell.bottomLabel.text = "Constructors"
            cell.topLabel.isHidden = true
            cell.layer.borderWidth = 4
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.enterYear.isHidden = true
            F1ApiRoutes.allConstructors(seasonYear: cell.enterYear.text)


        }
        if indexPath.item == 2 {
            cell.bottomLabel.text = "Drivers"
            cell.topLabel.isHidden = true
            cell.layer.borderWidth = 4
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.enterYear.isHidden = true
            F1ApiRoutes.allDrivers(seasonYear: cell.enterYear.text)


        }
        if indexPath.item == 3 {
            cell.bottomLabel.text = "Circuits"
            cell.topLabel.isHidden = true
            cell.layer.borderWidth = 4
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.enterYear.isHidden = true
            F1ApiRoutes.allCircuits(seasonYear: cell.enterYear.text)


        }
        if indexPath.item == 4 {
            cell.bottomLabel.text = "F1 Data App"
            cell.topLabel.isHidden = true
            cell.layer.borderWidth = 4
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.enterYear.isHidden = true


        }
        
        return cell
    }
    

    
    
    // selecting a cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellIndexPath = indexPath.item
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myHomeCell", for: indexPath) as? myHomeCell {
            if indexPath.item == 0 {
                print("THIS IS THE TITLE CELL, maybe place to seleect ")
                
            }
            if indexPath.item == 1 {
                print("Constructors is selected")
                Data.whichQuery = 0
                // homeCollectionTransition
                homeModel.setQueryNum(enterYear: cell.enterYear, homeSelf: self)
            }
            if indexPath.item == 2 {
                print("Drivers is selected")
                Data.whichQuery = 1
                // homeCollectionTransition
                homeModel.setQueryNum(enterYear: cell.enterYear, homeSelf: self)

            }
            if indexPath.item == 3 {
                print("Circuits is selected")
                Data.whichQuery = 2
                // homeCollectionTransition
                homeModel.setQueryNum(enterYear: cell.enterYear, homeSelf: self)
            }
            if indexPath.item == 4 {
                print("cell is selected")

            }

        }
        
    }
    // deselectuing a cell - hides cell
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myHomeCell", for: indexPath) as? myHomeCell {
            print("Cell deselected")
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    
}
