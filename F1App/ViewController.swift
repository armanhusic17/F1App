//
//  ViewController.swift
//  F1App
//
//  Created by Arman Husic on 3/23/22.
//

import UIKit
//import SVProgressHUD

class ViewController: UIViewController {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var showConstructorsButton: UIButton!
    @IBOutlet weak var showDriversButton: UIButton!
    @IBOutlet weak var enterYear: UITextView!
    
    
    let f1routes = F1ApiRoutes()
    var decodedJSONObject:String = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup aft
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        formatUI()
    }
    

    func formatUI(){
        showConstructorsButton  .layer.cornerRadius = 15
        showDriversButton       .layer.cornerRadius = 15

        titleImage.alpha = 0.25
    }
    
    @IBAction func displayConstructors(_ sender: UIButton) {
        Data.whichQuery = 0
        Data.seasonYear = enterYear.text
        f1routes.allConstructors()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.performSegue(withIdentifier: "enterTransition", sender: self)
        }
    }
    
    @IBAction func displayDrivers(_ sender: UIButton) {
        Data.whichQuery = 1
        Data.seasonYear = enterYear.text
        f1routes.allDrivers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.performSegue(withIdentifier: "enterTransition", sender: self)
        }
        
    }
    
    
    
    
    

}

