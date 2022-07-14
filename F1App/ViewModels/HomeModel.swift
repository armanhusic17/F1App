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
    

    
    func showAlert(passSelf:HomeVC){
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
        
        
    }
    
    // format the ui on home vc
    func formatUI(showDriversButton:UIButton, showConstructorsButton:UIButton, circuitsButton:UIButton, enterYear:UITextView, progressView:UIView , titleImage:UIImageView, lastRaceView:UIView, lastRaceLabel:UILabel){
        
        showDriversButton       .isUserInteractionEnabled = true
        showConstructorsButton  .isUserInteractionEnabled = true
        circuitsButton          .isUserInteractionEnabled = true

        showConstructorsButton  .layer.cornerRadius       = 15
        lastRaceView            .layer.cornerRadius       = 25
        lastRaceLabel           .layer.cornerRadius       = 25
        showDriversButton       .layer.cornerRadius       = 15
        circuitsButton          .layer.cornerRadius       = 15
        enterYear               .layer.cornerRadius       = 15
        progressView            .isHidden                 = true
        titleImage              .alpha                    = 0.25
        
        lastRaceLabel           .layer.borderWidth = 1
        lastRaceLabel           .layer.borderColor = UIColor.white.cgColor
        lastRaceView           .layer.borderWidth = 1
        lastRaceView           .layer.borderColor = UIColor.white.cgColor

    }
    
    func resultsTransition(showDriversButton:UIButton, showConstructorsButton:UIButton, circuitsButton:UIButton, enterYear:UITextView, progressView:UIView , titleImage:UIImageView, lastRaceView:UIView,activityIndicator:UIActivityIndicatorView,homeSelf:HomeVC,f1ApiRoute: @escaping () -> Void){
        showDriversButton       .isUserInteractionEnabled = false
        showConstructorsButton  .isUserInteractionEnabled = false
        circuitsButton          .isUserInteractionEnabled = false
        f1ApiRoute()
        F1ApiRoutes.allCircuits(seasonYear: enterYear.text)
        progressView            .isHidden               = false
        activityIndicator       .startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + qTime) {
            showDriversButton      .isUserInteractionEnabled   = true
            showConstructorsButton .isUserInteractionEnabled   = true
            circuitsButton         .isUserInteractionEnabled   = true
            activityIndicator      .stopAnimating()
            progressView           .isHidden                   = true
            homeSelf.performSegue(withIdentifier: "enterTransition", sender: self)
        }
    }
    
    
    // this func sets up the resulting cells from selection on homeVC
    func setQueryNumber(showDriversButton:UIButton, showConstructorsButton:UIButton, circuitsButton:UIButton, enterYear:UITextView, progressView:UIView , titleImage:UIImageView, lastRaceView:UIView,activityIndicator:UIActivityIndicatorView,homeSelf:HomeVC){

        guard let year = Int(enterYear.text) else {return}
        let targetYear:Int?
        let maxYear = 2022
        if Data.whichQuery == 2 {
            targetYear = 1950
            if year < targetYear! || year > maxYear {
                print("WE DONT HAVE DATA ON Circuits BEFORE THIS SEASON")
                showAlert(passSelf: homeSelf)
            } else {
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
               
                resultsTransition( showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: progressView , titleImage: titleImage, lastRaceView: lastRaceView, activityIndicator: activityIndicator, homeSelf: homeSelf ,f1ApiRoute: {
                    F1ApiRoutes.allCircuits(seasonYear: thisSeason)
                })
            }
        } else if Data.whichQuery == 1 {
            targetYear = 2014
            if year < targetYear! || year > maxYear {
                print("WE DONT HAVE DATA ON DRIVERS BEFORE THIS SEASON")
                showAlert(passSelf: homeSelf)
            } else {
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                
                resultsTransition( showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: progressView , titleImage: titleImage, lastRaceView: lastRaceView, activityIndicator: activityIndicator, homeSelf: homeSelf ,f1ApiRoute: {
                    F1ApiRoutes.allDrivers(seasonYear: thisSeason)
                })
            }
        } else if Data.whichQuery == 0 {
            targetYear = 1950

            if year < targetYear! || year > maxYear {
                print("WE DONT HAVE DATA ON DRIVERS BEFORE THIS SEASON")
                showAlert(passSelf: homeSelf)
            } else {
                Data.seasonYearSelected = enterYear.text
                guard let thisSeason = Data.seasonYearSelected else { return }
                
                resultsTransition( showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: progressView , titleImage: titleImage, lastRaceView: lastRaceView, activityIndicator: activityIndicator, homeSelf: homeSelf ,f1ApiRoute: {
                    F1ApiRoutes.allConstructors(seasonYear: thisSeason)
                })
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
    
    
    func getLastRaceResult(enterYear:UITextView, mySelf:HomeVC){
        guard let year = enterYear.text else {return}
        
        if Int(year)! >= 2005 {
            F1ApiRoutes.getQualiResults(seasonYear: enterYear.text)
//            mySelf.lastRaceLabel.font = UIFont(name: "MarkerFelt-Thin", size: 28.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.98) {
                mySelf.lastRaceLabel.text = "Race Result from \(enterYear.text ?? "Year") : Round 1 \n\nRace Name : \((Data.raceName[safe: 0] ?? "Loading...") ?? ""  ) \n\n Position \(Data.qualiResults[safe: 0]?.position ?? "Loading...") : \(Data.qualiResults[safe: 0]?.driver.givenName ?? "Loading...") \(Data.qualiResults[safe: 0]?.driver.familyName ?? "Loading...")\n\n Constructor: \(Data.qualiResults[safe: 0]?.constructor.name ?? "Loading..." ) "
            }
        }
        
        

    }
    
    
    
    func clearTextFromLastRace(lastRaceLabel:UILabel, mySelf:HomeVC){
        mySelf.lastRaceLabel.text?.removeAll()
    }
    
}
