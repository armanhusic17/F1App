//
//  ConstructorsCollection_VC.swift
//  F1App
//
//  Created by Arman Husic on 4/12/22.
//

import Foundation
import UIKit
import MapKit

/// This is the inital collectionof results that appears when a user selects one of the 3 maain queries 
class FirstResults : UICollectionViewController, UICollectionViewDelegateFlowLayout, MKMapViewDelegate {

    
    var seasonYear:Int?
    var playerIndex:Int?
    var passedName:String?
    
    var collectionmodel = CollectionModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        addSwipeGesture()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Number of cells from model
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionmodel.howManyCells()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "closerLookTransition" {
            if let controller = segue.destination as? SecondaryResults {
                controller.playerIndex = playerIndex
            }
            
        }
        
        if let cell = collectionView.cellForItem(at:  [0,playerIndex ?? 0] ) as? frCell {
            DispatchQueue.main.async {
                cell.activitySpinner.stopAnimating()
                cell.activitySpinner.isHidden = true
            }
            
        }
    }
    
    func addSwipeGesture() {
       let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
       view.addGestureRecognizer(swipeGesture)
   }

    @objc func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            // Initialize or prepare for the transition
            break
            
        case .changed:
            // Calculate the progress of the transition based on the swipe gesture
            let progress = translation.x / view.bounds.width
            // You can update UI elements based on the progress if needed
            // For example, animate alpha or position of the current view controller's view
            
        case .ended:
            // Determine whether the swipe is enough to trigger the transition
            let threshold: CGFloat = 0.5
            if translation.x / view.bounds.width < -threshold {
                performSwipeTransition()
            } else {
                // The swipe didn't reach the threshold, so reset the view or cancel the transition
            }
            
        default:
            break
        }
    }

    func performSwipeTransition() {
        let homeVC = HomeQueries()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true, completion: nil)
    }
    
    
    // Size of cells from model
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionmodel.cellSizeFromQuery(view: view)
    }
    
    // setup for each individual cell, setting mapview delegate to each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! frCell
        
        cell.F1MapView.delegate = self
        
        collectionmodel.cellViewFormat(cell: cell)
        collectionmodel.cellLogic(cell: cell, indexPath: indexPath, mapView: cell.F1MapView, seasonYear: seasonYear ?? 0)
        cell.cellImage.layer.cornerRadius = 15
        cell.activitySpinner.isHidden = true
        cell.activitySpinner.stopAnimating()
        return cell
    }
    
    
    // selecting a cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let resultsModel = ResultsModel()

        let cellIndexPath = indexPath.item
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? frCell {
            
            if let cell = collectionView.cellForItem(at:  indexPath) as? frCell {
                DispatchQueue.main.async {
                    cell.activitySpinner.startAnimating()
                    cell.activitySpinner.isHidden = false
                }
                
            }
            
            
            cell.getCellIndexPath(myCell: cell, myCellIP: cellIndexPath)
            playerIndex = cellIndexPath

            if F1DataStore.whichQuery == 1 {
                print("THIS SHOULD TRIGGER GRABBING THE DRIVERS NAME AND USING IT TO QUERY THEIR STATS")
                var sortedIndices: [Int] = []
                if let firstDriverIndex = F1DataStore.racePosition.firstIndex(of: "1") {
                    for rank in 1...F1DataStore.racePosition.count {
                        if let index = F1DataStore.racePosition.firstIndex(of: "\(rank)") {
                            sortedIndices.append(index)
                        }
                    }
                }
                
                let dataIndex = sortedIndices[safe:indexPath.item] ?? 0
                print(F1DataStore.driverLastName[safe: dataIndex] ?? "")
                F1ApiRoutes.getDriverResults(driverId: ((F1DataStore.driverLastName[safe: dataIndex] ?? "") ?? ""), limit: 1000) {  success, races in
                    print(success)
                    if success {
                        // Process the 'races' array containing the driver's race results
                        for race in races {
                            // Access race information like raceName, circuit, date, etc.
                            for result in race.results! {
                                // Access driver-specific information like position, points, fastest lap, etc.
                                F1DataStore.raceName.append("\(race.raceName ?? "loading...")")
                                F1DataStore.circuitName.append(race.circuit?.circuitName)
                                F1DataStore.raceDate.append(race.date)
                                F1DataStore.raceWinnerName.append("\(result.driver?.givenName ?? "loading...") \(result.driver?.familyName ?? "loading...")")
                                F1DataStore.driverFinishes.append("\(result.status ?? "loading...") : P\(result.position ?? "loading...") ")
                                F1DataStore.raceTime.append("Pace: \(result.time?.time ?? "")")
                                F1DataStore.raceWinnerTeam.append("Constructor : \(result.constructor?.name ?? "loading...")")
                                F1DataStore.driverPoles.append("Qualified : P\(result.grid ?? "loading...") ")
                                F1DataStore.driverTotalStarts.append(races.count)
                            }
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                            self.performSegue(withIdentifier: "closerLookTransition", sender: self)
                        }
                    } else {
                        print("WDC CLOSER LOOK TRANSITION FAIL")
                    }
                }
            }
            else if F1DataStore.whichQuery == 2 {
                print("SEASON YEAR BELOW")
                print(seasonYear, cellIndexPath + 1)
                F1ApiRoutes.allRaceResults(seasonYear: F1DataStore.seasonYearSelected ?? "1950", round: "\(cellIndexPath + 1)") { Success in
                    F1DataStore.seasonRound = cellIndexPath
                    
                    
                    if Success {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                            self.performSegue(withIdentifier: "closerLookTransition", sender: self)
                        }
                    } else {
                        print("Error getting qualifying results......")
                    }

                }

            }
            else if F1DataStore.whichQuery == 3 {
          
                
            } // end whichquery == 3
            
            
            else {
                resultsModel.loadResults(myself: self)
                if let cell = collectionView.cellForItem(at:  [0,playerIndex ?? 0] ) as? frCell {
                    DispatchQueue.main.async {
                        cell.activitySpinner.stopAnimating()
                        cell.activitySpinner.isHidden = true
                    }
                    
                }
                
            }
            
        }
        
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        F1DataStore.driverNationality.removeAll()
        F1DataStore.driverURL.removeAll()
        F1DataStore.driverNames.removeAll()
        F1DataStore.driverFirstNames.removeAll()
        F1DataStore.driverDOB.removeAll()
        F1DataStore.driverNumber.removeAll()
        F1DataStore.driverCode.removeAll()
        F1DataStore.driverImgURL.removeAll()
        F1DataStore.driverWikiImgURL.removeAll()
        F1DataStore.driverLastName.removeAll()
        // Team Data
        F1DataStore.constructorID.removeAll()
        F1DataStore.teamURL.removeAll()
        F1DataStore.teamNames.removeAll()
        F1DataStore.teamNationality.removeAll()
        F1DataStore.teamImgURL.removeAll()
        // Circuit Data
        F1DataStore.circuitCity.removeAll()
        F1DataStore.circuitID.removeAll()
        F1DataStore.circuitName.removeAll()
        F1DataStore.circuitLocation.removeAll()
        F1DataStore.circuitURL.removeAll()
        
        // Circuit Data Continued
        F1DataStore.raceURL.removeAll()
        F1DataStore.raceTime.removeAll()
        F1DataStore.raceDate.removeAll()
        F1DataStore.raceName.removeAll()
        F1DataStore.f1Season.removeAll()
        
        F1DataStore.circuitLatitude.removeAll()
        F1DataStore.circuitLongitude.removeAll()
        
        F1DataStore.raceWins.removeAll()
        F1DataStore.racePoints.removeAll()
        F1DataStore.raceWinnerName.removeAll()
        F1DataStore.raceDate.removeAll()
        F1DataStore.circuitRaceDate.removeAll()
        F1DataStore.racePosition.removeAll()
        F1DataStore.raceWinnerTeam.removeAll()
        F1DataStore.qualiResults.removeAll()
        
        if let cell = collectionView.cellForItem(at:  [0,playerIndex ?? 0] ) as? frCell {
            DispatchQueue.main.async {
                cell.activitySpinner.stopAnimating()
                cell.activitySpinner.isHidden = true
            }
            
        }
    }
    
    
    

    
}



