//
//  ViewController.swift
//  F1App
//
//  Created by Arman Husic on 3/23/22.
//

import UIKit
import Lottie

class HomeVC: UIViewController {
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
    let homeModel = HomeModel()
    let collectionModel = CollectionModel()
    
    private var animationView: AnimationView?
    private var animationView2: AnimationView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup
        lottieAnimationPlaying(animationName: "107761-formula-one",
                               animationName2:"82023-racing-car-steering-wheel",
                               subView: lastRaceView,
                               subView2:titleAnimationview )
    }
    
    func lottieAnimationPlaying(animationName:String, animationName2:String , subView:UIView, subView2:UIView){
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

        subView.addSubview(animationView!)
        subView2.addSubview(animationView2!)
        
        subView.layer.borderWidth = 20
        subView.layer.borderColor = UIColor.yellow.cgColor
        subView.alpha = 0.85
        // 6. Play animation
        animationView!.play()
        animationView2!.play()

    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        homeModel.formatUI(showDriversButton: showDriversButton, showConstructorsButton: showConstructorsButton, circuitsButton: circuitsButton, enterYear: enterYear, progressView: titleAnimationview, titleImage: titleImage, lastRaceView: lastRaceView)
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

