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
        
        // Deque a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleResultCell", for: indexPath) as! singleResultCell
        // Get create all of the vars that will go in the cell
        // load all the 
        if let driverNamed = Data.driverNames[safe: indexPath.item] ?? "[Driver Name]",
           let driverPosition = Data.racePosition[safe: indexPath.item] ?? "???",
           let constructorID = Data.constructorID[safe: indexPath.item] ?? "[Constructor Name]",
           let topSpeed = Data.raceTime[safe: indexPath.item] ?? "TOP",
           let fastestLap = Data.fastestLap[safe: indexPath.item] ?? "???" {
            // Use the unwrapped values to configure your cell
            cell.driverName.text = "P\(driverPosition)\n\(driverNamed)"
            cell.botLabel.text = "Constructor: \(constructorID)\nFastest Lap : \(fastestLap)\n"
            +
            "Top Speed: \(topSpeed) KPH"
        }
        
        if indexPath.item == 0 {
            cell.layer.borderColor = UIColor.red.cgColor
        }
        else if indexPath.item % 2 == 1 {
            cell.layer.borderColor = UIColor.yellow.cgColor
        }
        else {
            cell.layer.borderColor = UIColor.white.cgColor
        }
        
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        return cell
        
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
