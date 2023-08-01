//
//  HomeModel.swift
//  F1App
//
//  Created by Arman Husic on 6/22/22.
//

import Foundation
import UIKit
import Lottie

struct HomeModel {
    
    
    var decodedJSONObject:String = ""
    var seasonRound:String?
    var seasonYear:String?
    

    
    func showAlert(passSelf:HomeCollection){
        switch Data.whichQuery {
        case 0:
            let alert = UIAlertController(title: "Available Years for Constructor Data", message: "Only Data 1950 - Present available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style {
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("ERROR IN ALERT STYLE")
                }
            }))
            passSelf.present(alert, animated: true, completion: nil)
            
        case 1:
            let alert = UIAlertController(title: "Available Years for Driver Data", message: "Only 2014 - Present.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style {
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("ERROR IN ALERT STYLE")
                }
            }))
            passSelf.present(alert, animated: true, completion: nil)
            
        case 2:
            let alert = UIAlertController(title: "Available Years for Circuit Data", message: "Only 1950 to Present", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style {
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("ERROR IN ALERT STYLE")
                }
            }))
            passSelf.present(alert, animated: true, completion: nil)
            
        case 3:
            let alert = UIAlertController(title: "Available Years for Standings Data", message: "Only 1950 to Present", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style {
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("ERROR IN ALERT STYLE")
                }
            }))
            passSelf.present(alert, animated: true, completion: nil)
            
        case 4:
            let alert = UIAlertController(title: "Available Years for Qualifying Data", message: "Only 2004 to Present", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style {
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("ERROR IN ALERT STYLE")
                }
            }))
            passSelf.present(alert, animated: true, completion: nil)
            
        default:
            break
        }

        
        
    } // end showAlert
    
    
    func showResults(qTime: Double, activityIndicator: UIActivityIndicatorView, homeSelf: HomeCollection) {
        DispatchQueue.main.async {
            DispatchQueue.main.asyncAfter(deadline: .now() + qTime) {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
                homeSelf.collectionView.isUserInteractionEnabled = true
                homeSelf.performSegue(withIdentifier: "homeCollectionTransition", sender: self)
            }
        }
    }

    func returnYear() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let currentYear = dateFormatter.string(from: Date())
        return Int(currentYear) ?? 2000
    }
    
    
    func setQueryNum(activityIndicator:UIActivityIndicatorView, enterYear:UITextView, homeSelf:HomeCollection, cellIndex:IndexPath) {
        guard let year = Int(enterYear.text) else {return}
        let targetYear:Int?
        let maxYear = returnYear()
        // TEAMS QUERY
        if Data.whichQuery == 0 {
            targetYear = 1950
            if year < targetYear! || year > maxYear {
                print("WE DONT HAVE DATA ON TEAMS BEFORE THIS SEASON")
                showAlert(passSelf: homeSelf)
            } else {
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                print(thisSeason)
                F1ApiRoutes.allConstructors(seasonYear: thisSeason) { Success in
                    if Success {
                        print("SUCCESSS ALL CONSTRUCTORS")
                        showResults(qTime: 0.15, activityIndicator: activityIndicator, homeSelf: homeSelf)
                    } else {
                        print("FAILURE TO SHOW ALL CONSTRUCTORS")
                    }
                }
            }
        }
        
        // DRIVERS QUERY
        else if Data.whichQuery == 1 {
            Data.seasonYearSelected = enterYear.text
            guard let thisSeason = Data.seasonYearSelected else { return }
            F1ApiRoutes.fetchAllDriversFrom(seasonYear: thisSeason) { Success in
                if Success {
                    showResults(qTime: 0.25, activityIndicator: activityIndicator, homeSelf: homeSelf)
                } else {
                    print("ERROR? - DRIVERS QUERY")
                }
            }
        }
        // GRAND PRIX QUERY
        else if Data.whichQuery == 2 {
            let upperBound = 2004
            targetYear = 1950
            if year >= targetYear ?? 1950 && year <= upperBound {
                print(year, targetYear!, maxYear)
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                print("RUNNING BEFORE 2004 QUERY")
                print(thisSeason)
                F1ApiRoutes.allCircuits(seasonYear: thisSeason) { Success in
                    if Success {
                        showResults(qTime: 0.10, activityIndicator: activityIndicator, homeSelf: homeSelf)
                    } else {
                        print("ERROR?")
                    }
                }
            }
            else if year > targetYear ?? 1950 && year > upperBound && year <= maxYear{
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                print("RUNNING MODERN DAY CIRCUITS QUERY")
                print(thisSeason)
                F1ApiRoutes.allCircuitsAfter2004(seasonYear: thisSeason) { Success in
                    if Success {
                        showResults(qTime: 0.10, activityIndicator: activityIndicator, homeSelf: homeSelf)
                    } else {
                        print("ERROR?")
                    }
                }
            }
            else if year < targetYear! || year > maxYear {
                print("WE DONT HAVE DATA ON Circuits BEFORE THIS SEASON")
                showAlert(passSelf: homeSelf)
            }
        }
        // WDC QUERY
        else if Data.whichQuery == 3 {
            targetYear = 1950
            if year < targetYear! || year > maxYear {
                print("WE DONT HAVE DATA ON TEAMS BEFORE THIS SEASON")
                showAlert(passSelf: homeSelf)
            } else {
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                print(thisSeason)
                F1ApiRoutes.worldDriversChampionshipStandings(seasonYear: thisSeason) { Success in
                    if Success {
                        if Success {
                            print("SUCCESSS TO SHOW ALL TIME DRIVER CHAMPIONSHIPS")
                            showResults(qTime: 0.15, activityIndicator: activityIndicator, homeSelf: homeSelf)
                        } else {
                            print("FAILURE TO SHOW ALL TIME DRIVER CHAMPIONSHIPS")
                        }
                        F1ApiRoutes.allTimeDriverChampionships() { Success in
                            DispatchQueue.main.async {
                                homeSelf.reloadInputViews()
                            }
                        }
                    } else {
                        print("FAILURE TO SHOW ALL TIME DRIVER CHAMPIONSHIPS")
                    }
                }
            }
        }

    }
    
    
    
    
}
