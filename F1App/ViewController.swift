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
    
    
    let f1routes = F1ApiRoutes()
    var decodedJSONObject:String = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup aft
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        f1routes.allConstructors()
        f1routes.allDrivers()
        formatUI()
    }
    

    func formatUI(){
        showConstructorsButton  .layer.cornerRadius = 15
        showDriversButton       .layer.cornerRadius = 15

        titleImage.alpha = 0.25
    }
    
    @IBAction func enterApp(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.performSegue(withIdentifier: "enterTransition", sender: self)
        }
    }
    
    
    
    
    
    

}

