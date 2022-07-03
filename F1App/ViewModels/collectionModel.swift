//
//  collectionModel.swift
//  F1App
//
//  Created by Arman Husic on 6/22/22.
//

import Foundation
import UIKit
import MapKit

struct CollectionModel {
    //
    
    let myData = Data()
    
    let teamNames = Data.teamNames
    let driverNames = Data.driverNames
    let constructorID = Data.constructorID
    let teamNationality = Data.teamNationality
    let driverNationality = Data.driverNationality
    

    let driverCode = Data.driverCode
    let driverNumbers = Data.driverNumber
    let driversGivenName = Data.driverFirstNames
    let driverDOB = Data.driverDOB
    

    let circuitName = Data.circuitName
    let circuitId = Data.circuitID
    let circuitLocation = Data.circuitLocation
    let circuitCity = Data.circuitCity
    let circuitLong = Data.circuitLongitude
    let circuitLat = Data.circuitLatitude
    
    let raceURL = Data.raceURL
    let raceName = Data.raceName
    let raceDate = Data.raceDate
    let raceTime = Data.raceTime
    let raceSeason = Data.f1Season
    let cellCountForCircuits = Data.cellCount
    
    func removeAllCellData(){
        // Driver Data
        Data.driverNationality.removeAll()
        Data.driverURL.removeAll()
        Data.driverNames.removeAll()
        Data.driverFirstNames.removeAll()
        Data.driverDOB.removeAll()
        Data.driverNumber.removeAll()
        Data.driverCode.removeAll()
        
        // Team Data
        Data.constructorID.removeAll()
        Data.teamURL.removeAll()
        Data.teamNames.removeAll()
        Data.teamNationality.removeAll()

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
        
        
        print("removed all data points from the arrays holding the cells")
    }
    
    func howManyCells() -> Int{
        if Data.whichQuery == 0 {
            return teamNames.count
        }
        
        if Data.whichQuery == 1 {
            return driverNames.count
        }
        
        if Data.whichQuery == 2 {
            print(circuitCity.count)
            print(circuitName.count)
            print(circuitId.count)
            guard let cellcount = cellCountForCircuits else {return 1}
            return cellcount
        }
        // arbitrary return
        return 1
    }
    
    func cellLogic(cell:myCell, indexPath:IndexPath, mapView:MKMapView){
        if Data.whichQuery == 0 {
            
            cell.topCellLabel.text = "\(self.teamNames[indexPath.item] ?? "")"
            cell.bottomCellLabel.text = self.teamNationality[indexPath.item]
            cell.bottomCellLabel2.text = "\(self.constructorID[indexPath.item]?.capitalized ?? "") \(self.raceSeason[indexPath.item]?.capitalized ?? "")"
            cell.F1MapView.isHidden = true
            cell.mapView.isHidden = true

            
        }
        if Data.whichQuery == 1 {
            
            cell.topCellLabel.text = "\(self.driversGivenName[indexPath.item]!) \(self.driverNames[indexPath.item]!) #\(self.driverNumbers[indexPath.item]!)"
            cell.bottomCellLabel.text = "Nationality: \(self.driverNationality[indexPath.item]!)\nBorn: \(self.driverDOB[indexPath.item]!)"
            cell.bottomCellLabel2.text = self.driverCode[indexPath.item]
            cell.F1MapView.isHidden = true
            cell.mapView.isHidden = true

        
        }
        if Data.whichQuery == 2 {
        
            cell.F1MapView.isHidden = false
            cell.mapView.isHidden = false

            cell.bottomCellLabel2.text = self.circuitName[indexPath.item]
            cell.topCellLabel.text = self.circuitLocation[indexPath.item]
            cell.bottomCellLabel.text = self.circuitCity[indexPath.item]

        }
    }
    
    
    func cellViewFormat(cell:myCell){
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 15
        cell.cellImage.layer.cornerRadius = 8
        cell.mapView.layer.cornerRadius = 12
        cell.F1MapView.layer.cornerRadius = 12
    }
    
    
}
