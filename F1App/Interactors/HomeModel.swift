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
    let qTime:Double = 1.75
    var seasonRound:String?
    var seasonYear:String?
    

    
    func showAlert(passSelf:HomeCollection){
        if Data.whichQuery == 0 {
            let alert = UIAlertController(title: "Available Years for Constructor Data", message: "Only Data 1950 - Present available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style{
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

        }
        else if Data.whichQuery == 1 {
            let alert = UIAlertController(title: "Available Years for Driver Data", message: "Only 2014 - Present.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style{
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

        }
        else if Data.whichQuery == 2 {
            let alert = UIAlertController(title: "Available Years for Circuit Data", message: "Only 1950 to Present", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style{
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

        }
        else if Data.whichQuery == 3 {
            let alert = UIAlertController(title: "Available Years for Standings Data", message: "Only 2004 to Present", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style{
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

        }
        else if Data.whichQuery == 4 {
            let alert = UIAlertController(title: "Available Years for Qualifying Data", message: "Only 2004 to Present", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style{
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

        }
        
        
    } // end showAlert
    
    
    func showResults(activityIndicator:UIActivityIndicatorView, homeSelf:HomeCollection, f1ApiRoute: @escaping () -> Void){
        f1ApiRoute()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + qTime) {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            homeSelf.performSegue(withIdentifier: "homeCollectionTransition", sender: self)
        }

    }
    
    func returnYear() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let currentYear = dateFormatter.string(from: Date())
        return Int(currentYear) ?? 2000
    }
    
    
    func setQueryNum(activityIndicator:UIActivityIndicatorView, enterYear:UITextView, homeSelf:HomeCollection, cellIndex:IndexPath){
        guard let year = Int(enterYear.text) else {return}
        let targetYear:Int?
        let maxYear = returnYear()
        
        
        if Data.whichQuery == 2 {
            let upperBound = 2004
            targetYear = 1950
            
            if year > targetYear ?? 1950 && year <= upperBound {
                print(year, targetYear!, maxYear)
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                print("RUNNING BEFORE 2004 QUERY")
                print(thisSeason)

                showResults(activityIndicator: activityIndicator, homeSelf: homeSelf) {
                    F1ApiRoutes.allCircuits(seasonYear: thisSeason)
                }
            }
            else if year > targetYear ?? 1950 && year > upperBound && year <= maxYear{
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                print("RUNNING MODERN DAY CIRCUITS QUERY")
                print(thisSeason)
                showResults(activityIndicator: activityIndicator, homeSelf: homeSelf) {
                    F1ApiRoutes.allCircuitsAfter2004(seasonYear: thisSeason)
                }
            }
            else if year < targetYear! || year > maxYear {
                print("WE DONT HAVE DATA ON Circuits BEFORE THIS SEASON")
                showAlert(passSelf: homeSelf)
            }
        }
        else if Data.whichQuery == 1 {
            targetYear = 2014
            if year < targetYear! || year > maxYear {
//                print("WE DONT HAVE DATA ON DRIVERS BEFORE THIS SEASON")
//                showAlert(passSelf: homeSelf)
                
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                print(thisSeason)
                
                F1ApiRoutes.allDriversBefore2014(seasonYear: thisSeason) { Success in
                    if Success {
                        showResults(activityIndicator: activityIndicator, homeSelf: homeSelf) {
                            print("Results being shown..")
                        }
                    } else {
                        print("ERROR?")
                    }
                }
                
                


            } else {
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                print(thisSeason)
                showResults(activityIndicator: activityIndicator, homeSelf: homeSelf) {
                    F1ApiRoutes.allDrivers(seasonYear: thisSeason)
                }
                

            }
        }
        else if Data.whichQuery == 0 {
            targetYear = 1950

            if year < targetYear! || year > maxYear {
                print("WE DONT HAVE DATA ON TEAMS BEFORE THIS SEASON")
                showAlert(passSelf: homeSelf)
            } else {
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                print(thisSeason)

                showResults(activityIndicator: activityIndicator, homeSelf: homeSelf) {
                    F1ApiRoutes.allConstructors(seasonYear: thisSeason)
                }
                

            }
        }
        else if Data.whichQuery == 3 {
            targetYear = 2004

            if year < targetYear! || year > maxYear {
                print("WE DONT HAVE DATA ON TEAMS BEFORE THIS SEASON")
                showAlert(passSelf: homeSelf)
            } else {
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                print(thisSeason)

                showResults(activityIndicator: activityIndicator, homeSelf: homeSelf) {
                    F1ApiRoutes.getStandings(seasonYear: thisSeason)
                }
                

            }
        }
        else if Data.whichQuery == 4 {
            targetYear = 2004

            if year < targetYear! || year > maxYear {
                print("WE DONT HAVE DATA ON TEAMS BEFORE THIS SEASON")
                showAlert(passSelf: homeSelf)
            } else {
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                print(thisSeason)

                showResults(activityIndicator: activityIndicator, homeSelf: homeSelf) {
                    F1ApiRoutes.getQualiResults(seasonYear: thisSeason, round: "\(cellIndex.item + 1)")
                }
                

            }
        }
        else if Data.whichQuery == 5 {
            targetYear = 1950

            if year < targetYear! || year > maxYear {
                print("WE DONT HAVE DATA ON TEAMS BEFORE THIS SEASON")
                showAlert(passSelf: homeSelf)
            } else {
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                print(thisSeason)

                showResults(activityIndicator: activityIndicator, homeSelf: homeSelf) {
                    F1ApiRoutes.allRaceResults(seasonYear: thisSeason)
                }
                

            }
        }
       
    }
    
    
    func lottieAnimationPlaying(animationName:String, animationName2:String , subView:UIView, subView2:UIView){
        var animationView: AnimationView?
        var animationView2: AnimationView?
        animationView = .init(name: animationName)
        animationView2 = .init(name: animationName2)

        
        animationView!.frame = subView.bounds
        animationView2!.frame = subView2.bounds

        // 3. Set animation content mode
        animationView!.contentMode = .scaleAspectFit
        
        animationView2!.contentMode = .scaleAspectFit
        // 4. Set animation loop mode
        animationView!.loopMode = .loop
        animationView2!.loopMode = .loop
        // 5. Adjust animation speed
        animationView!.animationSpeed = 0.85
        animationView2!.animationSpeed = 0.5

        //subView.addSubview(animationView!)
        subView2.addSubview(animationView2!)
        
        subView.layer.borderWidth = 23
        subView.layer.borderColor = UIColor.systemTeal.cgColor
        subView.alpha = 0.80
        // 6. Play animation
        //animationView!.play()
        animationView2!.play()

    }
    
    
    
    
}
