//
//  HomeModel.swift
//  F1App
//
//  Created by Arman Husic on 6/22/22.
//

import Foundation
import UIKit

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
    func formatUI(showDriversButton:UIButton, showConstructorsButton:UIButton, circuitsButton:UIButton, enterYear:UITextView, progressView:UIView , titleImage:UIImageView, lastRaceView:UIView){
        
        showDriversButton       .isUserInteractionEnabled = true
        showConstructorsButton  .isUserInteractionEnabled = true
        circuitsButton          .isUserInteractionEnabled = true

        showConstructorsButton  .layer.cornerRadius       = 15
        lastRaceView            .layer.cornerRadius       = 15
        showDriversButton       .layer.cornerRadius       = 15
        circuitsButton          .layer.cornerRadius       = 15
        enterYear               .layer.cornerRadius       = 15
        progressView            .isHidden                 = true
        titleImage              .alpha                    = 0.25
        
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
        
        if Data.whichQuery == 2 {
            targetYear = 1950
            if year < targetYear! {
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
            if year < targetYear! {
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

            if year < targetYear! {
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
    

    
    
    
}
