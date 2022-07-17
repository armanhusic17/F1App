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
    let circuitRaceDate = Data.circuitRaceDate
    
    let raceURL = Data.raceURL
    let raceName = Data.raceName
    let raceDate = Data.raceDate
    let raceTime = Data.raceTime
    let raceSeason = Data.f1Season
    
    let raceWins = Data.raceWins
    let racePoints = Data.racePoints
    let raceWinnerName = Data.raceWinnerName

    
    let cellCountForCircuits = Data.cellCount
    
    // removing data from cells to be able to load the data again
    // should expand this to actually keep the data but hide it when the old queries are selected
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
        
        Data.raceWins.removeAll()
        Data.racePoints.removeAll()
        Data.raceWinnerName.removeAll()
        Data.raceDate.removeAll()
        Data.circuitRaceDate.removeAll()
        
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
        if Data.whichQuery == 3 {
            return  Data.raceWins.count
        }
        // arbitrary return
        return 1
    }
    
    // setting size of each cell
    func cellSizeFromQuery(view:UIView) -> CGSize{
        let availableWidth = view.frame.width
        let availableHeight = view.frame.height
        let queryWidth:CGFloat?
        let queryHeight:CGFloat?
        
        if Data.whichQuery == 0 {
            queryWidth = availableWidth * 0.65
            queryHeight = availableHeight * 0.15
            return CGSize(width: queryWidth!, height: queryHeight!)
        } else if Data.whichQuery == 1 {
            queryWidth = availableWidth * 0.75
            queryHeight = availableHeight * 0.20
            return CGSize(width: queryWidth!, height: queryHeight!)
        } else if Data.whichQuery == 2 {
            queryWidth = availableWidth * 0.95
            queryHeight = availableHeight * 0.60
            return CGSize(width: queryWidth!, height: queryHeight!)
        } else if Data.whichQuery == 3 {
            queryWidth = availableWidth * 0.65
            queryHeight = availableHeight * 0.15
            return CGSize(width: queryWidth!, height: queryHeight!)
        }
        return CGSize(width: availableWidth * 0.95, height: availableHeight * 0.33)

    }
    
    // what data is shown in the each cell
    func cellLogic(cell:myCell, indexPath:IndexPath, mapView:MKMapView){
        switch Data.whichQuery {
        
        case 0: // constructor
            cell.topCellLabel.text = "\(self.teamNames[indexPath.item] ?? "")"
            cell.bottomCellLabel.text = self.teamNationality[indexPath.item]
//            cell.bottomCellLabel2.text = "\(self.constructorID[indexPath.item]?.capitalized ?? "") \(self.raceSeason[indexPath.item]?.capitalized ?? "")"
            cell.F1MapView.isHidden = true
            cell.mapView.isHidden = true
            cell.cellImage.image = UIImage(named: "F1Logo")
            break
            
        case 1: // drivers
            cell.topCellLabel.text = "\(self.driversGivenName[indexPath.item] ?? "First") \(self.driverNames[indexPath.item] ?? "Last")"
            cell.bottomCellLabel.text = "Nationality: \(self.driverNationality[indexPath.item]!)\nBorn: \(self.driverDOB[indexPath.item] ?? "DOB")"
            cell.bottomCellLabel2.text = "\(self.driverCode[indexPath.item] ?? "Driver Name") #\(self.driverNumbers[indexPath.item] ?? "Driver Number")"
            cell.cellImage.image = UIImage(named: "teamLH")

            cell.F1MapView.isHidden = true
            cell.mapView.isHidden = true
            break
            
        case 2: // circuits
            cell.F1MapView.isHidden = false
            cell.mapView.isHidden = false

            let initialLocation = CLLocation(latitude: Double((circuitLat[safe: indexPath.item] ?? "")!) ?? 1.0, longitude: Double((circuitLong[safe: indexPath.item] ?? "")!) ?? 1.0)
            cell.F1MapView.centerToLocation(initialLocation)

            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 500000)
            cell.F1MapView.setCameraZoomRange(zoomRange, animated: true)
            cell.cellImage.image = UIImage(named: "circuitLogo")
            cell.bottomCellLabel2.text = "\(self.circuitName[indexPath.item] ?? "")"
            cell.topCellLabel.text = "\(self.circuitCity[indexPath.item] ?? "City"), \(self.circuitLocation[indexPath.item] ?? "Country")"
            cell.bottomCellLabel.text = "Round \((indexPath.item + 1)), \((self.circuitRaceDate[safe: indexPath.item] ?? "") ?? "")"
            cell.mapView.layer.borderWidth = 2
            cell.mapView.layer.borderColor = UIColor.lightGray.cgColor
            break
        case 3: // Standings
            cell.bottomCellLabel2.isHidden = false
            cell.bottomCellLabel.isHidden = false
            cell.topCellLabel.isHidden = false

            cell.topCellLabel.text = "\(raceWinnerName[safe: indexPath.item] ?? "" )"
            cell.bottomCellLabel.text = "Wins : \(raceWins[safe: indexPath.item] ?? "")"
            cell.bottomCellLabel2.text = "Point Total : \(racePoints[safe: indexPath.item] ?? "")"
            
            cell.mapView.isHidden = true
            cell.F1MapView.isHidden = true
            cell.cellImage.image = UIImage(named: "F1Logo")

        case .none:
            print("None")
        case .some(_):
            print("Some")
        }
    }
    
    // formatting the look of the cells
    func cellViewFormat(cell:myCell){
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 15
        cell.cellImage.layer.cornerRadius = 8
        cell.mapView.layer.cornerRadius = 12
        cell.F1MapView.layer.cornerRadius = 12
    }
    
    
    

    
    
}

// mapkit extension
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
