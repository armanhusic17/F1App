//
//  collectionModel.swift
//  F1App
//
//  Created by Arman Husic on 6/22/22.
//

import Foundation
import UIKit

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
    let raceURL = Data.raceURL
    
    
    func removeAllCellData(){
        Data.driverNationality.removeAll()
        Data.driverURL.removeAll()
        Data.driverNames.removeAll()
        Data.teamURL.removeAll()
        Data.teamNames.removeAll()
        Data.teamNationality.removeAll()
        Data.driverFirstNames.removeAll()
        Data.driverDOB.removeAll()
        Data.driverNumber.removeAll()
        Data.circuitURL.removeAll()
        Data.circuitID.removeAll()
        Data.circuitName.removeAll()
        Data.circuitLocation.removeAll()
        Data.driverCode.removeAll()
        Data.constructorID.removeAll()
        Data.circuitURL.removeAll()
        
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
            return circuitName.count
        }
        // arbitrary return
        return 1
    }
    
    func cellLogic(cell:myCell, indexPath:IndexPath){
        if Data.whichQuery == 0 {
            cell.topCellLabel.text = self.teamNames[indexPath.item]
            cell.bottomCellLabel.text = self.teamNationality[indexPath.item]
            cell.bottomCellLabel2.text = self.constructorID[indexPath.item]
        }
        if Data.whichQuery == 1 {
            cell.topCellLabel.text = "\(self.driversGivenName[indexPath.item]!) \(self.driverNames[indexPath.item]!) #\(self.driverNumbers[indexPath.item]!)"
            cell.bottomCellLabel.text = "Nationality: \(self.driverNationality[indexPath.item]!)\nBorn: \(self.driverDOB[indexPath.item]!)"
            cell.bottomCellLabel2.text = self.driverCode[indexPath.item]
        }
        if Data.whichQuery == 2 {
            cell.topCellLabel.text = self.circuitName[indexPath.item]
            cell.bottomCellLabel.text = self.circuitLocation[indexPath.item]
            cell.bottomCellLabel2.text = self.circuitId[indexPath.item]?.uppercased()
            
        }
    }
    
    func cellViewFormat(cell:myCell){
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.purple.cgColor
        cell.layer.cornerRadius = 15
        cell.cellImage.layer.cornerRadius = 8
    }
    
    
}
