//
//  F1ApiModel.swift
//  F1App
//
//  Created by Arman Husic on 6/17/22.
//

import Foundation
import Formula1API


struct F1ApiModel {
    
    
    func printFormula1Stat(){
        Formula1API.allCircuits { result in
            print(result)
        }
    }
    
}
