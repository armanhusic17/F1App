//
//  ViewController.swift
//  F1App
//
//  Created by Arman Husic on 3/23/22.
//

import UIKit

class HomeVC: UIViewController , UINavigationControllerDelegate{
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var showConstructorsButton: UIButton!
    @IBOutlet weak var showDriversButton: UIButton!
    @IBOutlet weak var enterYear: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var circuitsButton: UIButton!
    @IBOutlet weak var lastRaceView: UIView!
    @IBOutlet weak var lastRaceLabel: UILabel!
    @IBOutlet weak var titleAnimationview: UIView!
    
    
    let f1routes = F1ApiRoutes()
    var homeModel = HomeModel()
    let collectionModel = CollectionModel()
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup
        navigationController?.delegate = self

        homeModel.lottieAnimationPlaying(animationName: "107761-formula-one",
                               animationName2:"82023-racing-car-steering-wheel",
                               subView: lastRaceView,
                               subView2:titleAnimationview )
    }
    
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            print("Showing self now")
            homeModel.getLastRaceResult(enterYear: enterYear, mySelf: self)
            F1ApiRoutes.getStandings(seasonYear: enterYear.text)
            F1ApiRoutes.getData(seasonYear: enterYear.text)

        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DISAPPEARING")
        dismissKeyboard()
        homeModel.clearTextFromLastRace(lastRaceLabel: lastRaceLabel, mySelf: self)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        homeModel.formatUI(showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: titleAnimationview, titleImage: titleImage, lastRaceView: lastRaceView, lastRaceLabel: lastRaceLabel)
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
        // set the query number so that we can access on collectionVC and display correct number of cells
        Data.whichQuery = 0
        // teams
        homeModel.setQueryNumber(showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: titleAnimationview, titleImage: titleImage, lastRaceView: lastRaceView, activityIndicator: activityIndicator, homeSelf: self)
    }
    
    @IBAction func displayDrivers(_ sender: UIButton) {
        // set the query number so that we can access on collectionVC and display correct number of cells
        Data.whichQuery = 1
        // drivers
        homeModel.setQueryNumber(showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: titleAnimationview, titleImage: titleImage, lastRaceView: lastRaceView, activityIndicator: activityIndicator, homeSelf: self)
                

    }
    
    @IBAction func displayCircuits(_ sender: UIButton) {
        // set the query number so that we can access on collectionVC and display correct number of cells
        Data.whichQuery = 2
        // circuits
        homeModel.setQueryNumber(showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: titleAnimationview, titleImage: titleImage, lastRaceView: lastRaceView, activityIndicator: activityIndicator, homeSelf: self)
        
    }
    

    
  

    
    
    
    

}

