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
class ResultsCollection : UICollectionViewController, UICollectionViewDelegateFlowLayout, MKMapViewDelegate {

    var collectionmodel = CollectionModel()
    let resultsModel = ResultsModel()
    let myData = Data()
    
    var seasonYear:Int?
    var playerIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
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
            let controller = segue.destination as? SingleResultCollection
            controller?.playerIndex = playerIndex
        }
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
        return cell
    }
    
    
    // selecting a cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellIndexPath = indexPath.item
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? myCell {
            print("Cell is selected")
            cell.activitySpinner.isHidden = false
            cell.activitySpinner.startAnimating()
            
            cell.getCellIndexPath(myCell: cell, myCellIP: cellIndexPath)
            if Data.whichQuery == 1 {
                playerIndex = cellIndexPath
                F1ApiRoutes.getDriverResults(driverId: (Data.driverNames[safe: playerIndex ?? 0] ?? "")!, limit: 1000) { [self] success, races in
                    if success {
                        // Process the 'races' array containing the driver's race results
                        for race in races {
                            // Access race information like raceName, circuit, date, etc.
                            for result in race.results {
                                // Access driver-specific information like position, points, fastest lap, etc.
                                print("========================================================")
                                Data.raceName.append("\(race.raceName)")
                                Data.circuitName.append(race.circuit.circuitName)
                                print(race.raceName)
                                print(race.circuit.circuitName)
                                Data.raceDate.append(race.date)
                                print(race.date)
                                print("\(result.driver.givenName) \(result.driver.familyName) ")
                                print("\(result.status) : P\(result.position)")
                                Data.driverFinishes.append("\(result.status) : P\(result.position)")
                                Data.raceTime.append("Pace: \(result.time?.time ?? "")")
                                print("Pace: \(result.time?.time ?? "")")
                                print("\(result.constructor.name)")
                                Data.raceWinnerTeam.append("Constructor : \(result.constructor.name)")
                                print("Qualifying Position : P\(result.grid) ")
                                Data.driverPoles.append("Qualifying Position : P\(result.grid) ")
                                print("========================================================")
                            }
                            
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                            self.performSegue(withIdentifier: "closerLookTransition", sender: self)
                        }
    //                    print(F1ApiRoutes.countFinishedP1Occurrences(in: Data.driverFinishes))
    //                    print(F1ApiRoutes.countPoles(in: Data.driverPoles))
                    } else {
                        // Handle the error case
                        print("error")
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
            
            else {
                resultsModel.loadResults(myself: self)
            }
        }
    }
    // deselectuing a cell - hides cell
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? myCell {
            print("Cell deselected")
            cell.self.isHidden = false
            cell.activitySpinner.stopAnimating()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        myData.removeAllCellData()
    }
    
    
    

    
}



