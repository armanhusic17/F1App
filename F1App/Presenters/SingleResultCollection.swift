//
//  SingleResultCollection.swift
//  F1App
//
//  Created by Arman Husic on 3/20/23.
//

import Foundation
import UIKit

/// This is the single race result collection that appears when you select any cellin the grandprix's query
/// We can adapt this collection to display more than race results, for example quali results from that race, etc
class SingleResultCollection: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var midContentView: UIView!
    @IBOutlet weak var botBarView: UIView!
    @IBOutlet weak var closerLookCollection: UICollectionView!
    @IBOutlet weak var topBarLabel: UILabel!
    
    let myData = Data()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closerLookCollection.delegate = self
        closerLookCollection.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.95, height: view.frame.height * 0.23)

    }
    
    @objc
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(Data.driverNames)
        return Data.driverNames.count
    }
    
    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleResultCell", for: indexPath) as! singleResultCell

        // Extract all the necessary variables
        let driverName = Data.driverNames[safe: indexPath.item] ?? "[Driver Name]"
        let driverPosition = Data.racePosition[safe: indexPath.item] ?? "???"
        let constructorID = Data.constructorID[safe: indexPath.item] ?? "[Constructor Name]"
        let topSpeed = Data.raceTime[safe: indexPath.item] ?? ""
        let fastestLap = Data.fastestLap[safe: indexPath.item] ?? "???"
        
        // Configure the cell using the extracted variables
        cell.driverName.text = "P\(driverPosition!)\n\(driverName!)"
        cell.botLabel.text = "Constructor: \(constructorID!)\n\(fastestLap!)\n\(topSpeed!)"
        
        // Set the border color based on the item's index
        if indexPath.item == 0 {
            cell.layer.borderColor = UIColor.red.cgColor
        } else if indexPath.item % 2 == 1 {
            cell.layer.borderColor = UIColor.yellow.cgColor
        } else {
            cell.layer.borderColor = UIColor.white.cgColor
        }
        
        // Set other cell properties
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        
        // Set the top bar label text
        if let singleRaceName = Data.singleRaceName {
            topBarLabel.text = singleRaceName
        } else {
            topBarLabel.text = "Race Results"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myData.removeAllSingleResultData()
        let driverName = Data.driverNames[safe: indexPath.item] ?? "[Driver Name]"
        let driverPosition = Data.racePosition[safe: indexPath.item] ?? "???"
        let constructorID = Data.constructorID[safe: indexPath.item] ?? "[Constructor Name]"
        let topSpeed = Data.raceTime[safe: indexPath.item] ?? ""
        let fastestLap = Data.fastestLap[safe: indexPath.item] ?? "???"
        let url = Data.driverURL[safe: indexPath.item] ?? ""
        let driverLastName = Data.driverLastName[safe: indexPath.item] ?? "[Driver Last Name]"


        if Data.whichQuery == 2 {
            F1ApiRoutes.getDriverResults(driverId: driverLastName?.removingPercentEncoding ?? "", limit: 2000 ) { [self] success, races in
                print(driverLastName ?? "")
                if success {
                    // Process the 'races' array containing the driver's race results
                    for race in races {
                        // Access race information like raceName, circuit, date, etc.
                        for result in race.results {
                            // Access driver-specific information like position, points, fastest lap, etc.
                            print("========================================================")
                            print(race.raceName)
                            print(race.circuit.circuitName)
                            print(race.date)
                            print("\(result.driver.givenName) \(result.driver.familyName) ")
                            print("\(result.status) : P\(result.position)")
                            Data.driverFinishes.append("\(result.status) : P\(result.position)")
                            print("Pace: \(result.time?.time ?? "")")
                            print("\(result.constructor.name)")
                            print("Qualifying Position : P\(result.grid) ")
                            Data.driverPoles.append("Qualifying Position : P\(result.grid) ")
                            print("========================================================")
                        }
                        
                    }
                    print(countFinishedP1Occurrences(in: Data.driverFinishes))
                    print(countPoles(in: Data.driverPoles))
                } else {
                    // Handle the error case
                    print(driverLastName?.removingPercentEncoding)
                    print("error")
                }
            }


        }
        if Data.whichQuery == 3 {
            print(driverName ?? "")
            print(driverPosition ?? "")
        }
            
     
    }

    func countFinishedP1Occurrences(in array: [String?]) -> Int {
        let targetString = "Finished : P1"
        return array.filter { $0 == targetString }.count
    }
    
    func countPoles(in array: [String?]) -> Int {
        let targetString = "Qualifying Position : P1 "
        return array.filter { $0 == targetString }.count
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Data.driverNames.removeAll()
        Data.constructorID.removeAll()
        Data.racePosition.removeAll()
        Data.fastestLap.removeAll()
        Data.raceTime.removeAll()
    }
    
}
