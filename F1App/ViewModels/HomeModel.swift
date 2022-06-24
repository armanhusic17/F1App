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
    
}
