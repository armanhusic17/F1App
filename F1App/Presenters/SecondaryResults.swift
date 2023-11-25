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
class SecondaryResults: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var midContentView: UIView!
    @IBOutlet weak var botBarView: UIView!
    @IBOutlet weak var closerLookCollection: UICollectionView!
    @IBOutlet weak var topBarLabel: UILabel!
    
    var playerIndex:Int?
    var passedName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closerLookCollection.delegate = self
        closerLookCollection.dataSource = self
        
        // Using this method to scroll to bottom of the collection
        if F1DataStore.whichQuery == 0 {
        }
        // Drivers
        else if F1DataStore.whichQuery == 1 {
            DispatchQueue.main.async {
                let item = self.collectionView(self.closerLookCollection, numberOfItemsInSection: 0) - 1
                let lastItemIndex = IndexPath(item: item, section: 0)
                self.closerLookCollection.scrollToItem(at: lastItemIndex, at: .bottom, animated: false)
                self.closerLookCollection.reloadData()
            }
        }
        // Grand Prix
        else if F1DataStore.whichQuery == 2 {
        }
        // WDC
        else if F1DataStore.whichQuery == 3 {
            DispatchQueue.main.async {
                let item = self.collectionView(self.closerLookCollection, numberOfItemsInSection: 0) - 1
                let lastItemIndex = IndexPath(item: item, section: 0)
                self.closerLookCollection.scrollToItem(at: lastItemIndex, at: .bottom, animated: false)
                self.closerLookCollection.reloadData()
            }
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
        print(F1DataStore.driverNames)
        
        // Constructors
        if F1DataStore.whichQuery == 0 {
            return 1
        } // Drivers
        else if F1DataStore.whichQuery == 1 {
            return F1DataStore.driverFinishes.count
        } // Grand Prix
        else if F1DataStore.whichQuery == 2 {
            return F1DataStore.driverNames.count
        } // WDC
        else if F1DataStore.whichQuery == 3 {
            return  F1DataStore.driverFinishes.count
        } else {
            return F1DataStore.driverNames.count
        }
        return 1
    }
    
    
    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleResultCell", for: indexPath) as! srCell

        // Constructors
        if F1DataStore.whichQuery == 0 {
           
            
        }
        // Drivers
        else if F1DataStore.whichQuery == 1 {

            var sortedIndices: [Int] = []
            if let firstDriverIndex = F1DataStore.racePosition.firstIndex(of: "1") {
                for rank in 1...F1DataStore.racePosition.count {
                    if let index = F1DataStore.racePosition.firstIndex(of: "\(rank)") {
                        sortedIndices.append(index)
                    }
                }
            }
            
            let dataIndex = sortedIndices[safe:indexPath.item] ?? 0
            
            let driverFinishes = F1DataStore.driverFinishes[safe: indexPath.item] ?? "[Driver Frinishes]"
            let driverPoles = F1DataStore.driverPoles[safe: indexPath.item] ?? "[Driver Poles]"
            let race = F1DataStore.raceName[safe: indexPath.item] ?? "[Grand Prix]"
            let date = F1DataStore.raceDate[safe: indexPath.item] ?? "[Date]"
            let racePace = F1DataStore.raceTime[safe: indexPath.item] ?? "[Pace]"
            let circuitName = F1DataStore.circuitName[safe: indexPath.item] ?? "[Location]"
            let team = F1DataStore.raceWinnerTeam[safe: indexPath.item] ?? "[Team]"
            let totalPoles = countPoles(in: F1DataStore.driverPoles)
            let totalWins = countFinishedP1Occurrences(in: F1DataStore.driverFinishes)
            let totalStarts = F1DataStore.driverTotalStarts[safe: playerIndex ?? 0] ?? 0
            let name = passedName ?? ""
            
            topBarLabel.text = "\(name)\nPoles: \(totalPoles)\nWins: \(totalWins)\nRaces: \(totalStarts!)"
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
                
            
            }
        // Grand Prix
        else if F1DataStore.whichQuery == 2 {
            // Extract all the necessary variables
            let driverName = F1DataStore.driverNames[safe: indexPath.item] ?? "[Driver Name]"
            let driverPosition = F1DataStore.racePosition[safe: indexPath.item] ?? "???"
            let constructorID = F1DataStore.constructorID[safe: indexPath.item] ?? "[Constructor Name]"
            let topSpeed = F1DataStore.raceTime[safe: indexPath.item] ?? ""
            let fastestLap = F1DataStore.fastestLap[safe: indexPath.item] ?? "???"
            
            // Configure the cell using the extracted variables
            cell.driverName.text = "P\(driverPosition!) - \(driverName!)"
            cell.botLabel.text = "Constructor: \(constructorID!)\n\(fastestLap!)\n\(topSpeed!)"
            
            if let singleRaceName = F1DataStore.singleRaceName {
                topBarLabel.text = singleRaceName
            }
            
        }
        // WDC
        else if F1DataStore.whichQuery == 3 {
                              
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
        let driverName = F1DataStore.driverNames[safe: indexPath.item] ?? "[Driver Name]"
        let driverPosition = F1DataStore.racePosition[safe: indexPath.item] ?? "???"
        let constructorID = F1DataStore.constructorID[safe: indexPath.item] ?? "[Constructor Name]"
        let topSpeed = F1DataStore.raceTime[safe: indexPath.item] ?? ""
        let fastestLap = F1DataStore.fastestLap[safe: indexPath.item] ?? "???"
        let url = F1DataStore.driverURL[safe: indexPath.item] ?? ""
        let driverLastName = F1DataStore.driverLastName[safe: indexPath.item] ?? "[Driver Last Name]"

        // Grand Prix
        if F1DataStore.whichQuery == 2 {
            F1ApiRoutes.getLapTimes(index: indexPath.item, seasonYear: F1DataStore.seasonYearSelected ?? "2023", round: F1DataStore.seasonRound ?? 1, driverId: driverLastName ?? "") { Success in
                if Success {
                    print("Successfully returned driver laps")
                } else {
                    print("Failed to get driver laps from this race")
                }
            }
        }
        if F1DataStore.whichQuery == 3 {
            print(driverName ?? "")
            print(driverPosition ?? "")
        }

     
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        F1DataStore.constructorID.removeAll()
//        Data.racePosition.removeAll()
        F1DataStore.fastestLap.removeAll()
        F1DataStore.raceTime.removeAll()
        F1DataStore.driverFinishes.removeAll()
        F1DataStore.driverPoles.removeAll()
        F1DataStore.raceWinnerTeam.removeAll()
        F1DataStore.raceDate.removeAll()
        F1DataStore.circuitName.removeAll()
        F1DataStore.raceName.removeAll()
        F1DataStore.driverTotalStarts.removeAll()
        if F1DataStore.whichQuery != 1 || F1DataStore.whichQuery != 3 {
            F1DataStore.driverNames.removeAll()
            F1DataStore.driverFirstNames.removeAll()
        }
        
    }
}
