//
//  F1Data_Model.swift
//  F1App
//
//  Created by Arman Husic on 3/23/22.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON



struct F1ApiRoutes  {
    
  
    /**
        Here we will  set up some routes to the ergast api
        Set up a struct that can decode the json return by ergast
     */
    
    let myData = Data()
    
    func allDrivers(){
        let url = "https://ergast.com/api/f1/drivers.json"

        AF.request(url).response { response in
            debugPrint(response)
        }
    }
    
    
    
    func allConstructors(){
        let url = "https://ergast.com/api/f1/2021/constructors.json"
        
        guard let unwrappedURL = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: unwrappedURL) { (data, response, err) in
                    
            guard let data = data else {return}
            
            do {
                let f1Data = try JSONDecoder().decode(Constructors.self, from: data)
                let thisArray = f1Data.data.constructorTable.constructors
                
                for i in Range(0...thisArray.count - 1){
                    Data.teamNames.append(thisArray[i].name)
                    Data.teamNationality.append(thisArray[i].nationality)
                    Data.teamURL.append(thisArray[i].url)
                }
            } catch  {
                print("Error decoding json data ")
            }
        }.resume()
        
    }
    
    
    
    
    
    
}
