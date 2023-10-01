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
class FirstResultCollection : UICollectionViewController, UICollectionViewDelegateFlowLayout, MKMapViewDelegate {

    
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
            if let controller = segue.destination as? SingleResultCollection {
                controller.playerIndex = playerIndex

            }
            
        }
        
        if let cell = collectionView.cellForItem(at:  [0,playerIndex ?? 0] ) as? myCell {
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
        let homeVC = HomeCollection()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true, completion: nil)
    }
    
    
    // Size of cells from model
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionmodel.cellSizeFromQuery(view: view)
    }
    
    // setup for each individual cell, setting mapview delegate to each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! myCell
        
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? myCell {
            
            if let cell = collectionView.cellForItem(at:  indexPath) as? myCell {
                DispatchQueue.main.async {
                    cell.activitySpinner.startAnimating()
                    cell.activitySpinner.isHidden = false
                }
                
            }
            
            
            cell.getCellIndexPath(myCell: cell, myCellIP: cellIndexPath)
            playerIndex = cellIndexPath

            if Data.whichQuery == 1 {
                print("THIS SHOULD TRIGGER GRABBING THE DRIVERS NAME AND USING IT TO QUERY THEIR STATS")
                var sortedIndices: [Int] = []
                if let firstDriverIndex = Data.racePosition.firstIndex(of: "1") {
                    for rank in 1...Data.racePosition.count {
                        if let index = Data.racePosition.firstIndex(of: "\(rank)") {
                            sortedIndices.append(index)
                        }
                    }
                }
                
                let dataIndex = sortedIndices[safe:indexPath.item] ?? 0
                print(Data.driverLastName[safe: dataIndex] ?? "")
                F1ApiRoutes.getDriverResults(driverId: ((Data.driverLastName[safe: dataIndex] ?? "") ?? ""), limit: 1000) {  success, races in
                    print(success)
                    if success {
                        // Process the 'races' array containing the driver's race results
                        for race in races {
                            // Access race information like raceName, circuit, date, etc.
                            for result in race.results {
                                // Access driver-specific information like position, points, fastest lap, etc.
                                Data.raceName.append("\(race.raceName)")
                                Data.circuitName.append(race.circuit.circuitName)
                                Data.raceDate.append(race.date)
                                Data.raceWinnerName.append("\(result.driver.givenName) \(result.driver.familyName)")
                                Data.driverFinishes.append("\(result.status) : P\(result.position) ")
                                Data.raceTime.append("Pace: \(result.time?.time ?? "")")
                                Data.raceWinnerTeam.append("Constructor : \(result.constructor.name)")
                                Data.driverPoles.append("Qualified : P\(result.grid) ")
                                Data.driverTotalStarts.append(races.count)
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
            else if Data.whichQuery == 2 {
                print("SEASON YEAR BELOW")
                print(seasonYear, cellIndexPath + 1)
                F1ApiRoutes.allRaceResults(seasonYear: Data.seasonYearSelected ?? "1950", round: "\(cellIndexPath + 1)") { Success in
                    Data.seasonRound = cellIndexPath
                    if Success {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                            self.performSegue(withIdentifier: "closerLookTransition", sender: self)
                        }
                    } else {
                        print("Error getting qualifying results......")
                    }

                }

            }
            else if Data.whichQuery == 3 {
          
                
            } // end whichquery == 3
            
            
            else {
                resultsModel.loadResults(myself: self)
                if let cell = collectionView.cellForItem(at:  [0,playerIndex ?? 0] ) as? myCell {
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

        Data.driverNationality.removeAll()
        Data.driverURL.removeAll()
        Data.driverNames.removeAll()
        Data.driverFirstNames.removeAll()
        Data.driverDOB.removeAll()
        Data.driverNumber.removeAll()
        Data.driverCode.removeAll()
        Data.driverImgURL.removeAll()
        Data.driverWikiImgURL.removeAll()
        Data.driverLastName.removeAll()
        // Team Data
        Data.constructorID.removeAll()
        Data.teamURL.removeAll()
        Data.teamNames.removeAll()
        Data.teamNationality.removeAll()
        Data.teamImgURL.removeAll()
        // Circuit Data
        Data.circuitCity.removeAll()
        Data.circuitID.removeAll()
        Data.circuitName.removeAll()
        Data.circuitLocation.removeAll()
        Data.circuitURL.removeAll()
        
        // Circuit Data Continued
        Data.raceURL.removeAll()
        Data.raceTime.removeAll()
        Data.raceDate.removeAll()
        Data.raceName.removeAll()
        Data.f1Season.removeAll()
        
        Data.circuitLatitude.removeAll()
        Data.circuitLongitude.removeAll()
        
        Data.raceWins.removeAll()
        Data.racePoints.removeAll()
        Data.raceWinnerName.removeAll()
        Data.raceDate.removeAll()
        Data.circuitRaceDate.removeAll()
        Data.racePosition.removeAll()
        Data.raceWinnerTeam.removeAll()
        Data.qualiResults.removeAll()
        
        if let cell = collectionView.cellForItem(at:  [0,playerIndex ?? 0] ) as? myCell {
            DispatchQueue.main.async {
                cell.activitySpinner.stopAnimating()
                cell.activitySpinner.isHidden = true
            }
            
        }
    }
    
    
    

    
}



