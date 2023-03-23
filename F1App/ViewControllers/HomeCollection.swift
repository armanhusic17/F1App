//
//  homeCollection.swift
//  F1App
//
//  Created by Arman Husic on 7/14/22.
//

import Foundation
import UIKit
import Firebase

class HomeCollection: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    @IBOutlet weak var cellActivityIndicator: UIActivityIndicatorView!
    
    let f1routes = F1ApiRoutes()
    var homeModel = HomeModel()
    let collectionModel = CollectionModel()
    
    var seasonYear:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        navigationController?.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ResultsCollection {
            // Pass data to destinationVC here
            print("prepare function fires")
            destinationVC.seasonYear = seasonYear
            
        }
    }
    
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            print("Showing self now")
        }
    }
    
    func recognizeTap(){
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
            return CGSize(width: view.frame.height * 0.35, height: view.frame.height * 0.45)

        } else {
            return CGSize(width: view.frame.width * 0.49, height: view.frame.height * 0.30)

        }
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myHomeCell", for: indexPath) as! myHomeCell
        
        if indexPath.item == 0 {
            cell.bottomLabel.text = ""
            cell.topLabel.text = "Enter F1 Season"
            cell.enterF1SeasonYear.isHidden = false
            cell.enterF1SeasonYear.backgroundColor = UIColor.clear
            cell.homeCellImageView.image = UIImage(named: "Screen Shot 2022-04-12 at 9.47.47 PM")
            cell.homeBaseView.backgroundColor = UIColor.clear
            cell.layer.borderWidth = 0.0
            seasonYear = Int(cell.enterF1SeasonYear.text)
            print("First season year")
            print(seasonYear)

        }
        
        if indexPath.item == 1 {
            Data.whichQuery = 0
            cell.layer.borderWidth = 0.75
            cell.homeBaseView.backgroundColor = UIColor.lightGray
            cell.homeBaseView.alpha = 0.5
            cell.bottomLabel.text = "Constructors"
            cell.topLabel.isHidden = true
            cell.enterF1SeasonYear.isHidden = false
            cell.homeCellImageView.image = UIImage(named: "raceTeam")
            
        }
        
        if indexPath.item == 2 {
            Data.whichQuery = 1
            cell.layer.borderWidth = 0.75
            cell.homeBaseView.backgroundColor = UIColor.lightGray
            cell.homeBaseView.alpha = 0.5
            cell.bottomLabel.text = "Drivers"
            cell.topLabel.isHidden = true
            cell.enterF1SeasonYear.isHidden = false
            cell.homeCellImageView.image = UIImage(named: "lewis")
        }
        
        if indexPath.item == 3 {
            Data.whichQuery = 2
            cell.layer.borderWidth = 0.75

            cell.homeBaseView.backgroundColor = UIColor.lightGray
            cell.homeBaseView.alpha = 0.5
            cell.bottomLabel.text = "Grand Prix"
            cell.topLabel.isHidden = true
            cell.enterF1SeasonYear.isHidden = false
            cell.homeCellImageView.image = UIImage(named: "circuitLogo")

        }
        
        if indexPath.item == 4 {
            Data.whichQuery = 3
            cell.layer.borderWidth = 0.75
            cell.homeBaseView.backgroundColor = UIColor.lightGray
            cell.homeBaseView.alpha = 0.5
            cell.bottomLabel.text = "WDC"
            cell.topLabel.text = "Top 5"
            cell.enterF1SeasonYear.isHidden = false
            cell.homeCellImageView.image = UIImage(named: "F1Logo")
        }
        
        if indexPath.item == 5 {
            Data.whichQuery = 4
            cell.layer.borderWidth = 0.75
            cell.homeBaseView.backgroundColor = UIColor.lightGray
            cell.homeBaseView.alpha = 0.5
            cell.topLabel.text = "Top 10"
            cell.bottomLabel.text = "Quali Results"
            cell.enterF1SeasonYear.isHidden = false
            cell.homeCellImageView.image = UIImage(named: "F1Logo")
        }
        if indexPath.item == 6 {
            Data.whichQuery = 5
            cell.layer.borderWidth = 0.75
            cell.homeBaseView.backgroundColor = UIColor.lightGray
            cell.homeBaseView.alpha = 0.5
            cell.topLabel.text = "Race Results"
            cell.bottomLabel.text = "Still gathering data..."
            cell.enterF1SeasonYear.isHidden = false
            cell.homeCellImageView.image = UIImage(named: "F1Logo")
        }
        
        cell.layer.borderColor = UIColor.systemRed.cgColor
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    
    

    
    
    // selecting a cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myHomeCell", for: indexPath) as? myHomeCell {
            dismissKeyboard()
            cell.layer.borderColor = UIColor.clear.cgColor

            // have to disable cells so that the user doesnt send multiple queries as the data loads
            if indexPath.item == 0 {
                print("THIS IS THE TITLE CELL, maybe place to select year")
            }
            if indexPath.item == 1 {
                print("Constructors cell is selected")
                Data.whichQuery = 0  
                if let cell = collectionView.cellForItem(at:  [0,0]) as? myHomeCell {
                    homeModel.setQueryNum(activityIndicator: cellActivityIndicator, enterYear: cell.enterF1SeasonYear, homeSelf: self, cellIndex: indexPath)
                }
            }
            if indexPath.item == 2 {
                print("Drivers cell is selected")
                Data.whichQuery = 1
                if let cell = collectionView.cellForItem(at:  [0,0]) as? myHomeCell {
                    homeModel.setQueryNum(activityIndicator: cellActivityIndicator, enterYear: cell.enterF1SeasonYear, homeSelf: self, cellIndex: indexPath)
                }
            }
            if indexPath.item == 3 {
                print("Circuits cell is selected")
                Data.whichQuery = 2
                if let cell = collectionView.cellForItem(at:  [0,0]) as? myHomeCell {
                    homeModel.setQueryNum(activityIndicator: cellActivityIndicator, enterYear: cell.enterF1SeasonYear, homeSelf: self, cellIndex: indexPath)
                }
            }
            if indexPath.item == 4 {
                print("Standings cell is selected")
                Data.whichQuery = 3
                if let cell = collectionView.cellForItem(at:  [0,0]) as? myHomeCell {
                    homeModel.setQueryNum(activityIndicator: cellActivityIndicator, enterYear: cell.enterF1SeasonYear, homeSelf: self, cellIndex: indexPath)
                }
            }
            if indexPath.item == 5 {
                print("Standings cell is selected")
                Data.whichQuery = 4
                if let cell = collectionView.cellForItem(at:  [0,0]) as? myHomeCell {
                    homeModel.setQueryNum(activityIndicator: cellActivityIndicator, enterYear: cell.enterF1SeasonYear, homeSelf: self, cellIndex: indexPath)
                }
            }
            if indexPath.item == 6 {
                print("Race Results cell is selected")
                Data.whichQuery = 5
                if let cell = collectionView.cellForItem(at:  [0,0]) as? myHomeCell {
                    homeModel.setQueryNum(activityIndicator: cellActivityIndicator, enterYear: cell.enterF1SeasonYear, homeSelf: self, cellIndex: indexPath)
                }
            }
        }
        
    }
    
    
    // deselectuing a cell - hides cell
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myHomeCell", for: indexPath) as? myHomeCell {
            print("Cell deselected")
            dismissKeyboard()
            cell.homeBaseView.backgroundColor = UIColor.clear
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
    }
    
    
    
}
