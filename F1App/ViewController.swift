//
//  ViewController.swift
//  F1App
//
//  Created by Arman Husic on 3/23/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var showConstructorsButton: UIButton!
    @IBOutlet weak var showDriversButton: UIButton!
    @IBOutlet weak var enterYear: UITextView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var circuitsButton: UIButton!
    
    
    let f1routes = F1ApiRoutes()
    var decodedJSONObject:String = ""
    let qTime:Double = 1.75
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup aft
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        formatUI()

        print("Circuit DATA BELOW")

    
        
        
    }
    

    func formatUI(){
        
        showDriversButton       .isUserInteractionEnabled = true
        showConstructorsButton  .isUserInteractionEnabled = true
        circuitsButton  .isUserInteractionEnabled = true

        showConstructorsButton  .layer.cornerRadius       = 15
        showDriversButton       .layer.cornerRadius       = 15
        circuitsButton          .layer.cornerRadius       = 15
        enterYear               .layer.cornerRadius       = 15
        progressView            .isHidden                 = true
        titleImage              .alpha                    = 0.25
        
    }
    
    @IBAction func displayConstructors(_ sender: UIButton) {
        
        showDriversButton       .isUserInteractionEnabled = false
        showConstructorsButton  .isUserInteractionEnabled = false

        Data.whichQuery                                 = 0
        F1ApiRoutes.allConstructors(seasonYear: enterYear.text)
        progressView            .isHidden               = false
        activityIndicator       .startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + qTime) {
            self.showDriversButton      .isUserInteractionEnabled   = true
            self.showConstructorsButton .isUserInteractionEnabled   = true
            self.activityIndicator      .stopAnimating()
            self.progressView           .isHidden                   = true
            self.performSegue(withIdentifier: "enterTransition", sender: self)
        }
        
    }
    
    @IBAction func displayDrivers(_ sender: UIButton) {
        
        guard let year = Int(enterYear.text) else {return}
        print(year)
        if year < 2014 {
            print("WE DONT HAVE DATA ON DRIVERS BEFORE THIS SEASON")
        } else {
            showConstructorsButton  .isUserInteractionEnabled = false
            showDriversButton       .isUserInteractionEnabled = false
            Data.whichQuery                                   = 1
            F1ApiRoutes                .allDrivers(seasonYear: enterYear.text)
            progressView            .isHidden                 = false
            activityIndicator       .startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + qTime) {
                self.showDriversButton      .isUserInteractionEnabled = true
                self.showConstructorsButton .isUserInteractionEnabled = true
                self.activityIndicator      .stopAnimating()
                self.progressView           .isHidden                 = true
                self.performSegue(withIdentifier: "enterTransition", sender: self)
            }
        }
        
    }
    
    @IBAction func displayCircuits(_ sender: UIButton) {
        
        showDriversButton       .isUserInteractionEnabled = false
        showConstructorsButton  .isUserInteractionEnabled = false
        circuitsButton          .isUserInteractionEnabled = false
        Data.whichQuery                                 = 2
        F1ApiRoutes.allCircuits(seasonYear: enterYear.text)
        progressView            .isHidden               = false
        activityIndicator       .startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + qTime) {
            self.showDriversButton      .isUserInteractionEnabled   = true
            self.showConstructorsButton .isUserInteractionEnabled   = true
            self.circuitsButton         .isUserInteractionEnabled   = true
            self.activityIndicator      .stopAnimating()
            self.progressView           .isHidden                   = true
            self.performSegue(withIdentifier: "enterTransition", sender: self)
        }
        
    }
    
    
    
    

}

