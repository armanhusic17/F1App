//
//  QueryData.swift
//  F1App
//
//  Created by Arman Husic on 2/19/24.
//

import Foundation
import SwiftUI

class QueryData: ObservableObject {

    @Published var teamNames: [String] = []
    @Published var driverName: [String] = []
    @Published var grandPrix: [String] = []
    
}

