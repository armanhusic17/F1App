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
        recognizeTap()
        print("Circuit DATA BELOW")
        
        
        
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

    func formatUI(){
        
        showDriversButton       .isUserInteractionEnabled = true
        showConstructorsButton  .isUserInteractionEnabled = true
        circuitsButton          .isUserInteractionEnabled = true

        showConstructorsButton  .layer.cornerRadius       = 15
        showDriversButton       .layer.cornerRadius       = 15
        circuitsButton          .layer.cornerRadius       = 15
        enterYear               .layer.cornerRadius       = 15
        progressView            .isHidden                 = true
        titleImage              .alpha                    = 0.25
        
    }
    
    @IBAction func displayConstructors(_ sender: UIButton) {
        guard let year = Int(enterYear.text) else {return}
        Data.whichQuery                                 = 0
        
        if year < 1950 {
            print("WE DONT HAVE DATA ON DRIVERS BEFORE THIS SEASON")
            showAlert()
        } else {
        
            showDriversButton       .isUserInteractionEnabled = false
            showConstructorsButton  .isUserInteractionEnabled = false
            circuitsButton          .isUserInteractionEnabled = false
            F1ApiRoutes.allConstructors(seasonYear: enterYear.text)
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
    
    @IBAction func displayDrivers(_ sender: UIButton) {
        guard let year = Int(enterYear.text) else {return}
        Data.whichQuery                                   = 1
        
        if year < 2014 {
            print("WE DONT HAVE DATA ON DRIVERS BEFORE THIS SEASON")
            showAlert()
        } else {
            showConstructorsButton  .isUserInteractionEnabled = false
            showDriversButton       .isUserInteractionEnabled = false
            circuitsButton          .isUserInteractionEnabled = false
            F1ApiRoutes                .allDrivers(seasonYear: enterYear.text)
            progressView            .isHidden                 = false
            activityIndicator       .startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + qTime) {
                self.showDriversButton      .isUserInteractionEnabled = true
                self.showConstructorsButton .isUserInteractionEnabled = true
                self.circuitsButton         .isUserInteractionEnabled = true
                self.activityIndicator      .stopAnimating()
                self.progressView           .isHidden                 = true
                self.performSegue(withIdentifier: "enterTransition", sender: self)
            }
        }
        
    }
    
    @IBAction func displayCircuits(_ sender: UIButton) {
        guard let year = Int(enterYear.text) else {return}
        Data.whichQuery                                 = 2
        
        if year < 1950 {
            print("WE DONT HAVE DATA ON Circuits BEFORE THIS SEASON")
            showAlert()
        } else {
            showDriversButton       .isUserInteractionEnabled = false
            showConstructorsButton  .isUserInteractionEnabled = false
            circuitsButton          .isUserInteractionEnabled = false
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
    
  
    func showAlert(){
        
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
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)

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
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)

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
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)

        }
        
        
    }
    
    

}

