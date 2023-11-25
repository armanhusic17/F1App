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
    

    
    func showAlert(passSelf:HomeQueries){
        switch F1DataStore.whichQuery {
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
    
    
    func showResults(qTime: Double, homeSelf: HomeQueries) {
        DispatchQueue.main.asyncAfter(deadline: .now() + qTime) {
            homeSelf.collectionView.isUserInteractionEnabled = true
            homeSelf.performSegue(withIdentifier: "homeCollectionTransition", sender: self)
        }
    }

    func returnYear() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let currentYear = dateFormatter.string(from: Date())
        return Int(currentYear) ?? 2000
    }
    
    
    func setQueryNum(enterYear:UITextView, homeSelf:HomeQueries, cellIndex:IndexPath) {
        guard let year = Int(enterYear.text) else {return}
        let targetYear:Int?
        let maxYear = returnYear()
        // TEAMS QUERY
        if F1DataStore.whichQuery == 0 {
            targetYear = 1950
            if year < targetYear! || year > maxYear {
                print("WE DONT HAVE DATA ON TEAMS BEFORE THIS SEASON")
                showAlert(passSelf: homeSelf)
            } else {
                F1DataStore.seasonYearSelected = enterYear.text
                guard let thisSeason = F1DataStore.seasonYearSelected else { return }
                print(thisSeason)
                F1ApiRoutes.getConstructorStandings(seasonYear: thisSeason) { Success in
                    if Success {
                        print("SUCCESSS ALL CONSTRUCTORS")
                        showResults(qTime: 0.75, homeSelf: homeSelf)
                    } else {
                        print("FAILURE TO SHOW ALL CONSTRUCTORS")
                    }
                }
            }
        }
        
        // WORLD DRIVERS' CHAMPIONSHIP QUERY
        else if F1DataStore.whichQuery == 1 {

            targetYear = 1950
            if year < targetYear! || year > maxYear {
                print("WE DONT HAVE DATA ON TEAMS BEFORE THIS SEASON")
                showAlert(passSelf: homeSelf)
            } else {
                F1DataStore.seasonYearSelected = enterYear.text
                guard let thisSeason = F1DataStore.seasonYearSelected else { return }
                print(thisSeason)
                F1ApiRoutes.worldDriversChampionshipStandings(seasonYear: thisSeason) { Success in
                    if Success {
                        if Success {
                            print("SUCCESSS TO SHOW ALL WORLD DRIVER CHAMPIONSHIPS STATS")
                            showResults(qTime: 0.75, homeSelf: homeSelf)
                        } else {
                            print("FAILURE TO SHOW ALL TIME DRIVER CHAMPIONSHIPS")
                        }
                    } else {
                        print("FAILURE TO SHOW ALL TIME DRIVER CHAMPIONSHIPS")
                    }
                }
            }
        }
        // GRAND PRIX QUERY
        else if F1DataStore.whichQuery == 2 {
            let targetYear = 1950
            let upperBound = 2023

            if year >= targetYear && year <= upperBound {
                F1DataStore.seasonYearSelected = enterYear.text
                guard let thisSeason = F1DataStore.seasonYearSelected else { return }
                print("RUNNING QUERY")
                print(thisSeason)
            } else {
                print("WE DON'T HAVE DATA FOR THIS SEASON")
                showAlert(passSelf: homeSelf)
            }

            F1ApiRoutes.allRaceSchedule(seasonYear: F1DataStore.seasonYearSelected ?? "2023") { Success in
                if Success {
                    showResults(qTime: 0.75, homeSelf: homeSelf)
                } else {
                    print("ERROR?")
                }
            }

        }
        // WDC QUERY
        else if F1DataStore.whichQuery == 3 {

        }

    }
    
    
    
    
}
