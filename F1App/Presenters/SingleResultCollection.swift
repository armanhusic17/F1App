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
    
    var playerIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closerLookCollection.delegate = self
        closerLookCollection.dataSource = self
        
        if Data.whichQuery == 0 {
        } // Drivers
        else if Data.whichQuery == 1 {
            DispatchQueue.main.async {
                let item = self.collectionView(self.closerLookCollection, numberOfItemsInSection: 0) - 1
                let lastItemIndex = IndexPath(item: item, section: 0)
                self.closerLookCollection.scrollToItem(at: lastItemIndex, at: .bottom, animated: false)
                self.closerLookCollection.reloadData()
            }
        } // Grand Prix
        else if Data.whichQuery == 2 {
            
        } // WDC
        else if Data.whichQuery == 3 {
        }
        
        
        
    }
  
    func countFinishedP1Occurrences(in array: [String?]) -> Int {
        let targetString = "Finished : P1 "
        return array.filter { ($0?.localizedCaseInsensitiveContains(targetString) ?? false) }.count
    }

    func countPoles(in array: [String?]) -> Int {
        let targetString = "Qualified : P1 "
        return array.compactMap { $0 }.filter { $0.localizedCaseInsensitiveContains(targetString) }.count
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width * 0.95, height: view.frame.height * 0.28)
    }
    
    @objc
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(Data.driverNames)
        
        // Constructors
        if Data.whichQuery == 0 {
            return 1
        } // Drivers
        else if Data.whichQuery == 1 {
            return Data.driverFinishes.count
        } // Grand Prix
        else if Data.whichQuery == 2 {
            return Data.driverNames.count
        } // WDC
        else if Data.whichQuery == 3 {
            return 1
        } else {
            return Data.driverNames.count
        }
        return 1
    }
    
    
    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleResultCell", for: indexPath) as! singleResultCell

        // Constructors
        if Data.whichQuery == 0 {
           
            
        } // Drivers
        else if Data.whichQuery == 1 {
            
            let driverFinishes = Data.driverFinishes[safe: indexPath.item] ?? "[Driver Frinishes]"
            let driverPoles = Data.driverPoles[safe: indexPath.item] ?? "[Driver Poles]"
            let driver = Data.driverNames[safe: playerIndex ?? 0] ?? ""
            let driverGivenName = Data.driverFirstNames[safe: playerIndex ?? 0] ?? ""
            let race = Data.raceName[safe: indexPath.item] ?? "[Grand Prix]"
            let date = Data.raceDate[safe: indexPath.item] ?? "[Date]"
            let racePace = Data.raceTime[safe: indexPath.item] ?? "[Pace]"
            let circuitName = Data.circuitName[safe: indexPath.item] ?? "[Location]"
            let team = Data.raceWinnerTeam[safe: indexPath.item] ?? "[Team]"
            let totalPoles = countPoles(in: Data.driverPoles)
            let totalWins = countFinishedP1Occurrences(in: Data.driverFinishes)
           
            topBarLabel.text = "\(driverGivenName!) \(driver!)\nPoles: \(totalPoles)\nWins: \(totalWins)"
            topBarLabel.textColor = .white
            cell.driverName.text = "\(race!)"
            cell.botLabel.text = "\(circuitName!)"
                                    + "\n"
                                    + "\(date!)"
                                    + "\n"
                                    + "\(team!)"
                                    + "\n"
                                    + (driverPoles ?? "")
                                    + "\n"
                                    + (driverFinishes ?? "")
                                    + "\n"
                                    + "\(racePace!)"
                                    
            } // Grand Prix
        else if Data.whichQuery == 2 {
            // Extract all the necessary variables
            let driverName = Data.driverNames[safe: indexPath.item] ?? "[Driver Name]"
            let driverPosition = Data.racePosition[safe: indexPath.item] ?? "???"
            let constructorID = Data.constructorID[safe: indexPath.item] ?? "[Constructor Name]"
            let topSpeed = Data.raceTime[safe: indexPath.item] ?? ""
            let fastestLap = Data.fastestLap[safe: indexPath.item] ?? "???"
            
            // Configure the cell using the extracted variables
            cell.driverName.text = "P\(driverPosition!) - \(driverName!)"
            cell.botLabel.text = "Constructor: \(constructorID!)\n\(fastestLap!)\n\(topSpeed!)"
            
            if let singleRaceName = Data.singleRaceName {
                topBarLabel.text = singleRaceName
            }
            
        } // WDC
        else if Data.whichQuery == 3 {
            
        }
            
        
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
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let driverName = Data.driverNames[safe: indexPath.item] ?? "[Driver Name]"
//        let driverPosition = Data.racePosition[safe: indexPath.item] ?? "???"
//        let constructorID = Data.constructorID[safe: indexPath.item] ?? "[Constructor Name]"
//        let topSpeed = Data.raceTime[safe: indexPath.item] ?? ""
//        let fastestLap = Data.fastestLap[safe: indexPath.item] ?? "???"
//        let url = Data.driverURL[safe: indexPath.item] ?? ""
//        let driverLastName = Data.driverLastName[safe: indexPath.item] ?? "[Driver Last Name]"
//
//
//        if Data.whichQuery == 2 {
//            F1ApiRoutes.getDriverResults(driverId: driverLastName?.removingPercentEncoding ?? "", limit: 2000 ) { [self] success, races in
//                print(driverLastName ?? "")
//                if success {
//                    // Process the 'races' array containing the driver's race results
//                    for race in races {
//                        // Access race information like raceName, circuit, date, etc.
//                        for result in race.results {
//                            // Access driver-specific information like position, points, fastest lap, etc.
//                            print("========================================================")
//                            print(race.raceName)
//                            print(race.circuit.circuitName)
//                            print(race.date)
//                            print("\(result.driver.givenName) \(result.driver.familyName) ")
//                            print("\(result.status) : P\(result.position)")
//                            Data.driverFinishes.append("\(result.status) : P\(result.position)")
//                            print("Pace: \(result.time?.time ?? "")")
//                            print("\(result.constructor.name)")
//                            print("Qualifying Position : P\(result.grid) ")
//                            Data.driverPoles.append("Qualifying Position : P\(result.grid) ")
//                            print("========================================================")
//                        }
//
//                    }
////                    print(F1ApiRoutes.countFinishedP1Occurrences(in: Data.driverFinishes))
////                    print(F1ApiRoutes.countPoles(in: Data.driverPoles))
//                } else {
//                    // Handle the error case
//                    print(driverLastName?.removingPercentEncoding)
//                    print("error")
//                }
//            }
//
//
//        }
//        if Data.whichQuery == 3 {
//            print(driverName ?? "")
//            print(driverPosition ?? "")
//        }
//
     
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Data.constructorID.removeAll()
        Data.racePosition.removeAll()
        Data.fastestLap.removeAll()
        Data.raceTime.removeAll()
        Data.driverFinishes.removeAll()
        Data.driverPoles.removeAll()
        Data.raceWinnerTeam.removeAll()
        Data.raceDate.removeAll()
        Data.circuitName.removeAll()
        Data.raceName.removeAll()
        Data.driverNames.removeAll()
        Data.driverFirstNames.removeAll()
    }
}
