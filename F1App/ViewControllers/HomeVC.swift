//
//  ViewController.swift
//  F1App
//
//  Created by Arman Husic on 3/23/22.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var showConstructorsButton: UIButton!
    @IBOutlet weak var showDriversButton: UIButton!
    @IBOutlet weak var enterYear: UITextView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var circuitsButton: UIButton!
    @IBOutlet weak var lastRaceView: UIView!
    @IBOutlet weak var lastRaceLabel: UILabel!
    
    
    let f1routes = F1ApiRoutes()
    let homeModel = HomeModel()
    let collectionModel = CollectionModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup aft
        setupLastRaceResults()
    }
    
    func setupLastRaceResults(){
        F1ApiRoutes.lastRaceResults(completionHandler: {
            lastRaceLabel.text = Data.fastestLap[0]
        })
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        homeModel.formatUI(showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: progressView, titleImage: titleImage, lastRaceView: lastRaceView)
        recognizeTap()
        
    }
    
    func recognizeTap(){
        //Looks for single or multiple taps.
             let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    
    @IBAction func displayConstructors(_ sender: UIButton) {
        guard let year = Int(enterYear.text) else {return}
        Data.whichQuery = 0
        
        if year < 1950 {
            print("WE DONT HAVE DATA ON DRIVERS BEFORE THIS SEASON")
            homeModel.showAlert(passSelf: self)
        } else {
            homeModel.resultsTransition( showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: progressView , titleImage: titleImage, lastRaceView: lastRaceView, activityIndicator: activityIndicator, homeSelf: self ,f1ApiRoute: {
                F1ApiRoutes.allConstructors(seasonYear: self.enterYear.text)
            })
        }
        
    }
    
    @IBAction func displayDrivers(_ sender: UIButton) {
        guard let year = Int(enterYear.text) else {return}
        Data.whichQuery = 1
        
        if year < 2014 {
            print("WE DONT HAVE DATA ON DRIVERS BEFORE THIS SEASON")
            homeModel.showAlert(passSelf: self)
        } else {
            homeModel.resultsTransition( showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: progressView , titleImage: titleImage, lastRaceView: lastRaceView, activityIndicator: activityIndicator, homeSelf: self ,f1ApiRoute: {
                F1ApiRoutes.allDrivers(seasonYear: self.enterYear.text)
            })
        }
        
    }
    
    @IBAction func displayCircuits(_ sender: UIButton) {
        guard let year = Int(enterYear.text) else {return}
        Data.whichQuery = 2
        
        if year < 1950 {
            print("WE DONT HAVE DATA ON Circuits BEFORE THIS SEASON")
            homeModel.showAlert(passSelf: self)
        } else {
            Data.seasonYearSelected = enterYear.text
            guard let thisSeason = Data.seasonYearSelected else { return }
           
            homeModel.resultsTransition( showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: progressView , titleImage: titleImage, lastRaceView: lastRaceView, activityIndicator: activityIndicator, homeSelf: self ,f1ApiRoute: {
                F1ApiRoutes.allCircuits(seasonYear: thisSeason)
            })
        }
        
    }
    
  

    
    
    

}

