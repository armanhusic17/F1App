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
        // Do any additional setup
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
        // set the query number so that we can access on collectionVC and display correct number of cells

        Data.whichQuery = 0
        
        homeModel.setQueryNumber(showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: progressView, titleImage: titleImage, lastRaceView: lastRaceView, activityIndicator: activityIndicator, homeSelf: self)
    }
    
    @IBAction func displayDrivers(_ sender: UIButton) {
        // set the query number so that we can access on collectionVC and display correct number of cells
        Data.whichQuery = 1
        
        homeModel.setQueryNumber(showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: progressView, titleImage: titleImage, lastRaceView: lastRaceView, activityIndicator: activityIndicator, homeSelf: self)
    }
    
    @IBAction func displayCircuits(_ sender: UIButton) {
        // set the query number so that we can access on collectionVC and display correct number of cells

        Data.whichQuery = 2

        homeModel.setQueryNumber(showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: progressView, titleImage: titleImage, lastRaceView: lastRaceView, activityIndicator: activityIndicator, homeSelf: self)
    }
    
  

    
    
    

}

