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
    let driverImgs = Data.driverImgURL.compactMap { URL(string: $0!) }
    let teamsImgs = Data.teamImgURL.compactMap { URL(string: $0!) }
    let driverImgWiki = Data.driverWikiImgURL

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
    let raceWinnerTeam = Data.raceWinnerTeam
    
    let qualiResuls = Data.qualiResults
    
    let cellCountForCircuits = Data.cellCount
    
    // removing data from cells to be able to load the data again
    // should expand this to actually keep the data but hide it when the old queries are selected

    
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
            return  raceWins.count
        }
        if Data.whichQuery == 4 {
            return  qualiResuls.count
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
            queryWidth = availableWidth * 0.75
            queryHeight = availableHeight * 0.21
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
            queryWidth = availableWidth * 0.75
            queryHeight = availableHeight * 0.15
            return CGSize(width: queryWidth!, height: queryHeight!)
        } else if Data.whichQuery == 4 {
            queryWidth = availableWidth * 0.85
            queryHeight = availableHeight * 0.30
            return CGSize(width: queryWidth!, height: queryHeight!)
        }
        return CGSize(width: availableWidth * 0.95, height: availableHeight * 0.33)

    }
    
    // what data is shown in the each cell
    func cellLogic(cell:myCell, indexPath:IndexPath, mapView:MKMapView, seasonYear: Int){
        switch Data.whichQuery {
        
        case 0: // constructor
            let imageURL = self.teamsImgs[indexPath.item]
            let cleanedURL = URL(string: imageURL.absoluteString.components(separatedBy: ",")[1])
            if let imageURL = cleanedURL {
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    guard let imageData = data, error == nil else {
                        print("Error loading image from URL: \(imageURL)")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData)
                        cell.cellImage.image = image
                        cell.topCellLabel.text = "\(self.teamNames[indexPath.item] ?? "")"
                        cell.bottomCellLabel.text = self.teamNationality[indexPath.item]
                        
                    }
                }.resume()
            } else {
                print("Invalid URL: \(imageURL)")
            }
            cell.cellImage.layer.borderWidth = 1
            cell.cellImage.layer.borderColor = UIColor.white.cgColor
            cell.F1MapView.isHidden = true
            cell.mapView.isHidden = true
            cell.topCellLabel.text = "\(self.teamNames[indexPath.item] ?? "")"
            cell.bottomCellLabel.text = self.teamNationality[indexPath.item]
            break
                
        case 1: // drivers
            // getting drivers images from wikiAPI, will need to move this to the model
            let imageURL = self.driverImgs[safe: indexPath.item]
            print("Is this an image URL? ==> \(imageURL)")
            let cleanedURL = URL(string: imageURL?.absoluteString.components(separatedBy: ",")[safe: 1] ?? "")
            print("Clean url or number?? ==> \(cleanedURL)")
            
            if let imageURL = cleanedURL {
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    guard let imageData = data, error == nil else {
                        print("Error loading image from URL: \(imageURL)")
                        return
                    }
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData)
                        cell.cellImage.image = image
                       cell.topCellLabel.text = "\(self.driversGivenName[indexPath.item] ?? "First") \(self.driverNames[indexPath.item] ?? "Last")"
                       cell.bottomCellLabel.text = "Nationality: \(self.driverNationality[indexPath.item]!)" //\nBorn: \(self.driverDOB[indexPath.item] ?? "DOB")
                        guard let driverNumber = self.driverNumbers[safe: indexPath.item] else {
                            cell.bottomCellLabel2.text = ""
                            return
                        }

                        cell.bottomCellLabel2.text = "Driver# \(driverNumber ?? "")"
                    }
                    
                }.resume()
            } else {
                print("Invalid URL: \(imageURL)")
                cell.topCellLabel.text = "\(self.driversGivenName[indexPath.item] ?? "First") \(self.driverNames[indexPath.item] ?? "Last")"
                cell.bottomCellLabel.text = "Nationality: \(self.driverNationality[indexPath.item]!)" //\nBorn: \(self.driverDOB[indexPath.item] ?? "DOB")
                guard let driverNumber = self.driverNumbers[safe: indexPath.item] else {
                    cell.bottomCellLabel2.text = ""
                    return
                }

                cell.bottomCellLabel2.text = "Driver# \(driverNumber ?? "")"
            }
            cell.F1MapView.isHidden = true
            cell.mapView.isHidden = true
            break
            
        case 2: // circuits
            cell.F1MapView.isHidden = false
            cell.mapView.isHidden = false
            
            let circuitLatStr = circuitLat[safe: indexPath.item] ?? ""
            let circuitLongStr = circuitLong[safe: indexPath.item] ?? ""
            let circuitNameStr = circuitName[safe: indexPath.item] ?? ""
            let circuitCityStr = circuitCity[safe: indexPath.item] ?? "City"
            let circuitLocationStr = circuitLocation[safe: indexPath.item] ?? "Country"
            let circuitRaceDateStr = circuitRaceDate[safe: indexPath.item] ?? ""
            
            let initialLocation = CLLocation(latitude: Double(circuitLatStr!) ?? 1.0, longitude: Double(circuitLongStr!) ?? 1.0)
            cell.F1MapView.centerToLocation(initialLocation)

            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 500000)
            cell.F1MapView.setCameraZoomRange(zoomRange, animated: true)
            cell.cellImage.image = UIImage(named: "circuitLogo")
            cell.bottomCellLabel2.text = "\(circuitCityStr!), \(circuitLocationStr!)"
            cell.topCellLabel.text = circuitNameStr
            cell.bottomCellLabel.text = "Round \(indexPath.item + 1), \(circuitRaceDateStr!)"
            cell.mapView.layer.borderWidth = 2
            cell.mapView.layer.borderColor = UIColor.lightGray.cgColor

            break
        case 3: // Standings
            cell.bottomCellLabel2.isHidden = false
            cell.bottomCellLabel.isHidden = false
            cell.topCellLabel.isHidden = false

            cell.topCellLabel.text = "\(String(describing: raceWinnerName[indexPath.item] ?? "") )" + ", \(raceWinnerTeam[indexPath.item] ?? "")"
            cell.bottomCellLabel.text = "Wins : \(String(describing: raceWins[indexPath.item] ?? ""))"
            cell.bottomCellLabel2.text = "Point Total : \(String(describing: racePoints[indexPath.item] ?? ""))"
            
            cell.mapView.isHidden = true
            cell.F1MapView.isHidden = true
            cell.cellImage.image = UIImage(named: "F1Logo")
            break
        case 4: // Quali
            cell.cellImage.image = UIImage(named: "F1Logo")
            cell.topCellLabel.text = "\(raceName[safe: 0] ?? "")"
            cell.mapView.isHidden = true
            cell.F1MapView.isHidden = true
            cell.bottomCellLabel2.text = "Times: \n Q1:\(qualiResuls[safe: indexPath.item]!.q1),\n Q2:\(qualiResuls[safe: indexPath.item]?.q2 ?? ""),\n Q3:\(qualiResuls[safe: indexPath.item]?.q3 ?? "") "
            cell.bottomCellLabel.text = "P\(qualiResuls[safe: indexPath.item]!.position) \n\(Data.qualiResults[safe: indexPath.item]!.driver.givenName) \(Data.qualiResults[safe: indexPath.item]!.driver.familyName) #\(Data.qualiResults[safe: indexPath.item]!.number)"
            
            break
        case .none:
            print("None")
        case .some(_):
            print("Some")
        } // end Data.WhichQuery
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
