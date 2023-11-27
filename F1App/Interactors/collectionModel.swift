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
    
    
    let teamNames = F1DataStore.teamNames
    let driverNames = F1DataStore.driverNames
    let constructorID = F1DataStore.constructorID
    let teamNationality = F1DataStore.teamNationality
    let driverNationality = F1DataStore.driverNationality
    

    let driverCode = F1DataStore.driverCode
    let driverNumbers = F1DataStore.driverNumber
    let driversGivenName = F1DataStore.driverFirstNames
    let driverDOB = F1DataStore.driverDOB
    let driverImgs = F1DataStore.driverImgURL.compactMap { URL(string: $0!) }
    let teamsImgs = F1DataStore.teamImages
    let driverImgWiki = F1DataStore.driverWikiImgURL
    let driverTitles = F1DataStore.driverChampionships
    
    let circuitName = F1DataStore.circuitName
    let circuitId = F1DataStore.circuitID
    let circuitLocation = F1DataStore.circuitLocation
    let circuitCity = F1DataStore.circuitCity
    let circuitLong = F1DataStore.circuitLongitude
    let circuitLat = F1DataStore.circuitLatitude
    let circuitRaceDate = F1DataStore.circuitRaceDate
    
    let raceURL = F1DataStore.raceURL
    let raceName = F1DataStore.raceName
    let raceDate = F1DataStore.raceDate
    let raceTime = F1DataStore.raceTime
    let raceSeason = F1DataStore.f1Season
    let finishes = F1DataStore.driverFinishes
    
    let raceWins = F1DataStore.raceWins
    let racePoints = F1DataStore.racePoints
    let racePosition = F1DataStore.racePosition
    let raceWinnerName = F1DataStore.raceWinnerName
    let raceWinnerTeam = F1DataStore.raceWinnerTeam
    
    let qualiResuls = F1DataStore.qualiResults
    
    let cellCountForCircuits = F1DataStore.cellCount
    

    // removing data from cells to be able to load the data again
    // should expand this to actually keep the data but hide it when the old queries are selected

    
    func howManyCells() -> Int{
        if F1DataStore.whichQuery == 0 {
            return teamNames.count
        }
        if F1DataStore.whichQuery == 1 {
            return driverNames.count
        }
        if F1DataStore.whichQuery == 2 {
            return raceName.count
        }
        if F1DataStore.whichQuery == 3 {
            return  driverNames.count
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
        
        if F1DataStore.whichQuery == 0 {
            queryWidth = availableWidth * 0.95
            queryHeight = availableHeight * 0.33
            return CGSize(width: queryWidth!.rounded(), height: queryHeight!)
        } else if F1DataStore.whichQuery == 1 {
            queryWidth = availableWidth * 0.95
            queryHeight = availableHeight * 0.35
            return CGSize(width: queryWidth!.rounded(), height: queryHeight!)
        } else if F1DataStore.whichQuery == 2 {
            queryWidth = availableWidth * 0.95
            queryHeight = availableHeight * 0.60
            return CGSize(width: queryWidth!.rounded(), height: queryHeight!)
        } else if F1DataStore.whichQuery == 3 {
            queryWidth = availableWidth * 0.95
            queryHeight = availableHeight * 0.28
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
                completion(UIImage(named: "default"))
                return
            }

            let image = UIImage(data: imageData)
            completion(image)
        }.resume()
    }

    
    func cellLogic(cell: frCell, indexPath: IndexPath, mapView: MKMapView, seasonYear: Int) {
        switch F1DataStore.whichQuery {
        case 0:
            configureConstructorCell(cell: cell, indexPath: indexPath)
        case 1:
            configureWDCCell(cell: cell, indexPath: indexPath)
        case 2:
            configureCircuitCell(cell: cell, indexPath: indexPath, mapView: mapView)
        case 3:
            print("OLD QUERY")
        case .none:
            print("None")
        case .some(_):
            print("Some")
        }
    }

    func configureConstructorCell(cell: frCell, indexPath: IndexPath) {
        let teamName = F1DataStore.teamNames[indexPath.item] ?? ""
        guard let imageUrlString = F1DataStore.teamImages[teamName] else {return}
        
        let imageUrl = URL(string: imageUrlString)
        print(imageUrl)

        cell.cellImage.contentMode = .scaleAspectFill
        loadImage(withURL: imageUrl) { image in
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
                cell.bottomCellLabel.text = "\(raceWinnerTeam[indexPath.item] ?? "")\nPoints: \(racePoints[indexPath.item] ?? "")\nNationality: \(self.teamNationality[indexPath.item] ?? "")"
            }
        }

        cell.cellImage.layer.borderWidth = 1
        cell.cellImage.layer.borderColor = UIColor.white.cgColor
        cell.F1MapView.isHidden = true
        cell.mapView.isHidden = true
    }

    func configureWDCCell(cell: frCell, indexPath: IndexPath) {
        // Existing WDC logic here...
        cell.cellImage.contentMode = .scaleAspectFill
        cell.bottomCellLabel2.isHidden = false
        cell.bottomCellLabel.isHidden = false
        cell.topCellLabel.isHidden = false
        
        var sortedIndices: [Int] = []
        if let firstDriverIndex = racePosition.firstIndex(of: "1") {
            for rank in 1...racePosition.count {
                if let index = racePosition.firstIndex(of: "\(rank)") {
                    sortedIndices.append(index)
                }
            }
        }
        
        let dataIndex = sortedIndices[safe:indexPath.item] ?? 0

        let currentYear = Calendar.current.component(.year, from: Date())
        let isCurrentYear = (Int(raceSeason[0]!) ?? 0) == currentYear

        if let racePosition = racePosition[safe: dataIndex] {
            var rankText = ""
            if isCurrentYear && racePosition == "1" {
                rankText = "Championship Leader"
            } else if racePosition == "1" {
                rankText = "Champion"
            } else {
                rankText = "WDC Rank: \(racePosition ?? "")"
            }
            
            cell.bottomCellLabel.text = "\(raceSeason[0]!) \(rankText)"
        } else {
            cell.bottomCellLabel.text = "\(raceSeason[0]!) WDC Rank: N/A"
        }


        
        if let driverName = driverNames[safe: dataIndex] {
            cell.topCellLabel.text = driverName
        } else {
            cell.topCellLabel.text = "Driver Name: N/A"
        }
        
        if let racePoint = racePoints[safe: dataIndex] {
            cell.bottomCellLabel.text = "\(cell.bottomCellLabel.text ?? "")\nPoints: \(racePoint ?? "")"
        } else {
            cell.bottomCellLabel.text = "\(cell.bottomCellLabel.text ?? "")\nPoints: N/A"
        }
        
        if let teamName = teamNames[safe: dataIndex] {
            cell.bottomCellLabel2.text = "Constructor: \(teamName ?? "")"
        }
        
        if let driverTitle = driverTitles[safe: dataIndex] {
            let formattedKey = driverTitle.key.replacingOccurrences(of: "_", with: " ")
            let capitalizedKey = formattedKey.capitalized
            cell.bottomCellLabel.text = "\(cell.bottomCellLabel.text ?? "")\nAll Time #\(dataIndex + 1): \(capitalizedKey)\n\(driverTitle.value)-Time WDC"
        }
        
        
        cell.mapView.isHidden = true
        cell.F1MapView.isHidden = true
        
        // Load driver image using the same method as case 1
        let imageURL = F1DataStore.driverImgURL[safe: dataIndex]
        let cleanedURL = URL(string: (imageURL ?? "lewis")!)
        
        loadImage(withURL: cleanedURL) { image in
            DispatchQueue.main.async {
                if image != nil {
                    cell.cellImage.image = image
                } else {
                    cell.cellImage.contentMode = .scaleAspectFill
                    cell.cellImage.image = UIImage(named: "lewis")
                }
            } // end main
        }
        
        if indexPath.item == 0 {
            cell.layer.borderColor = UIColor.systemYellow.cgColor
        } else {
            
        }

    }

    func configureCircuitCell(cell: frCell, indexPath: IndexPath, mapView: MKMapView) {
        // Existing circuit logic here...
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

    }

    

    
    // formatting the look of the cells
    func cellViewFormat(cell:frCell){
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 15
        cell.cellImage.layer.cornerRadius = 8
        cell.mapView.layer.cornerRadius = 12
        cell.F1MapView.layer.cornerRadius = 12
    }
    

    func getDriverResults(indexPath: IndexPath, sortedIndices: [Int], mySelf: UIViewController){
        let dataIndex = sortedIndices[safe:indexPath.item] ?? 0
        print(F1DataStore.driverLastName[safe: dataIndex] ?? "")
        
        F1ApiRoutes.getDriverResults(driverId: ((F1DataStore.driverLastName[safe: dataIndex] ?? "") ?? ""), limit: 1000) {  success, races in
            print(success)
            if success {
                // Process the 'races' array containing the driver's race results
                for race in races {
                    // Access race information like raceName, circuit, date, etc.
                    for result in race.results! {
                        // Access driver-specific information like position, points, fastest lap, etc.
                        F1DataStore.raceName.append("\(race.raceName ?? "loading...")")
                        F1DataStore.circuitName.append(race.circuit?.circuitName)
                        F1DataStore.raceDate.append(race.date)
                        F1DataStore.raceWinnerName.append("\(result.driver?.givenName ?? "loading...") \(result.driver?.familyName ?? "loading...")")
                        F1DataStore.driverFinishes.append("\(result.status ?? "loading...") : P\(result.position ?? "loading...") ")
                        F1DataStore.raceTime.append("Pace: \(result.time?.time ?? "")")
                        F1DataStore.raceWinnerTeam.append("Constructor : \(result.constructor?.name ?? "loading...")")
                        F1DataStore.driverPoles.append("Qualified : P\(result.grid ?? "loading...") ")
                        F1DataStore.driverTotalStarts.append(races.count)
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                    mySelf.performSegue(withIdentifier: "closerLookTransition", sender: mySelf)
                }
            } else {
                print("WDC CLOSER LOOK TRANSITION FAIL")
            }
        }
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
