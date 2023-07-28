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
    let driverTitles = Data.driverChampionships
    
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
    let racePosition = Data.racePosition
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
            return  driverNames.count
        }
//        if Data.whichQuery == 4 {
//            return  qualiResuls.count
//        }
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
            queryWidth = availableWidth * 0.95
            queryHeight = availableHeight * 0.33
            return CGSize(width: queryWidth!.rounded(), height: queryHeight!)
        } else if Data.whichQuery == 1 {
            queryWidth = availableWidth * 0.95
            queryHeight = availableHeight * 0.35
            return CGSize(width: queryWidth!.rounded(), height: queryHeight!)
        } else if Data.whichQuery == 2 {
            queryWidth = availableWidth * 0.95
            queryHeight = availableHeight * 0.60
            return CGSize(width: queryWidth!.rounded(), height: queryHeight!)
        } else if Data.whichQuery == 3 {
            queryWidth = availableWidth * 0.75
            queryHeight = availableHeight * 0.25
            return CGSize(width: queryWidth!.rounded(), height: queryHeight!)
        }
        return CGSize(width: availableWidth * 0.95, height: availableHeight * 0.33)

    }
    
    // Define a new method to load the driver's image asynchronously
    func loadImage(withURL imageURL: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = imageURL else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let imageData = data, error == nil else {
                print("Error loading image from URL: \(imageURL)")
                completion(nil)
                return
            }

            let image = UIImage(data: imageData)
            completion(image)
        }.resume()
    }

    



    
    
    // what data is shown in the each cell
    func cellLogic(cell:myCell, indexPath:IndexPath, mapView:MKMapView, seasonYear: Int){
        switch Data.whichQuery {
        
        case 0: // constructor
            let imageURL = self.teamsImgs[indexPath.item]
            let cleanedURL = URL(string: imageURL.absoluteString.components(separatedBy: ",")[1])
            cell.cellImage.contentMode = .scaleAspectFill
            loadImage(withURL: cleanedURL) { image in
                DispatchQueue.main.async {
                    if image != nil {
                        cell.cellImage.image = image
                        cell.cellImage.alpha = 1.0

                    } else {
                        cell.cellImage.contentMode = .scaleAspectFit
                        cell.cellImage.image = UIImage(named: "f1Car")
                        cell.cellImage.alpha = 0.5
                    }
                    cell.topCellLabel.text = "\(self.teamNames[indexPath.item] ?? "")"
                    cell.bottomCellLabel.text = "Nationality: \(self.teamNationality[indexPath.item] ?? "")"
                }
            }
            
            cell.cellImage.layer.borderWidth = 1
            cell.cellImage.layer.borderColor = UIColor.white.cgColor
            cell.F1MapView.isHidden = true
            cell.mapView.isHidden = true
            cell.topCellLabel.text = "Constructor: \(self.teamNames[indexPath.item] ?? "")"
            cell.bottomCellLabel.text = "Nationality: \(self.teamNationality[indexPath.item] ?? "")"
            break
                
        case 1: // drivers
            cell.F1MapView.isHidden = true
            cell.mapView.isHidden = true
            
            
            let imageURL = self.driverImgs[safe: indexPath.item]
            let cleanedURL = URL(string: imageURL?.absoluteString.components(separatedBy: ",")[safe: 1] ?? "")
            print(imageURL)
            print(cleanedURL)
        
            loadImage(withURL: cleanedURL ?? imageURL) { image in
                DispatchQueue.main.async {
                    if image != nil {
                        cell.cellImage.image = image

                    } else {
                        cell.cellImage.contentMode = .scaleAspectFill
                        cell.cellImage.image = UIImage(named: "lewis")
                    }
                }
            }
            cell.topCellLabel.text = "\(self.driversGivenName[indexPath.item] ?? "First") \(self.driverNames[indexPath.item] ?? "Last")"
            cell.bottomCellLabel.text = "Nationality: \(self.driverNationality[indexPath.item]!)" //\nBorn: \(self.driverDOB[indexPath.item] ?? "DOB")

            guard let dob = self.driverDOB[safe: indexPath.item] else {
                cell.bottomCellLabel2.text = ""
                return
            }

            cell.bottomCellLabel2.text = "DOB: \(dob ?? "")"
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
            cell.cellImage.isHidden = true
            cell.cellImage2.image = UIImage(named: "circuitLogo")
            cell.bottomCellLabel2.text = "\(circuitCityStr!), \(circuitLocationStr!)"
            cell.topCellLabel.text = circuitNameStr
            cell.bottomCellLabel.text = "Round \(indexPath.item + 1)"+", \(circuitRaceDateStr!)"
            cell.mapView.layer.borderWidth = 2
            cell.mapView.layer.borderColor = UIColor.lightGray.cgColor

            break
        case 3: // WDC
            cell.cellImage.contentMode = .scaleAspectFit
            cell.bottomCellLabel2.isHidden = true
            cell.bottomCellLabel.isHidden = false
            cell.topCellLabel.isHidden = false
            
            if let racePosition = racePosition[safe: indexPath.item] {
                cell.bottomCellLabel.text = "\(raceSeason[0]!)" + " WDC Rank: \(racePosition!)"
            } else {
                cell.bottomCellLabel.text = "WDC Rank: N/A"
            }
            
            if let driverName = driverNames[safe: indexPath.item] {
                cell.topCellLabel.text = driverName
            } else {
                cell.topCellLabel.text = "Driver Name: N/A"
            }
            
            if let racePoint = racePoints[safe: indexPath.item] {
                cell.bottomCellLabel.text = "\(cell.bottomCellLabel.text ?? "")\nPoints: \(racePoint!)"
            } else {
                cell.bottomCellLabel.text = "\(cell.bottomCellLabel.text ?? "")\nPoints: N/A"
            }
            
            if let driverTitle = driverTitles[safe: indexPath.item] {
                let formattedKey = driverTitle.key.replacingOccurrences(of: "_", with: " ")
                let capitalizedKey = formattedKey.capitalized
                cell.bottomCellLabel.text = "\(cell.bottomCellLabel.text ?? "")\nAll Time #\(indexPath.item + 1): \(capitalizedKey)\n\(driverTitle.value)-Time WDC"
            }
            
            cell.mapView.isHidden = true
            cell.F1MapView.isHidden = true
            cell.cellImage.image = UIImage(named: "WDCLogo")
            
            if indexPath.item == 0 {
                cell.cellImage.alpha = 1
            } else {
                cell.cellImage.alpha = 0.45
            }
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
    func centerToLocation(_ location: CLLocation,regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
            setRegion(coordinateRegion, animated: true)
    }
}
