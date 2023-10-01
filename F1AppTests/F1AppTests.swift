//
//  F1AppTests.swift
//  F1AppTests
//
//  Created by Arman Husic on 3/23/22.
//

import XCTest
@testable import F1App

class F1AppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    
    func testTest(){
        let home = HomeModel()
        let collection = CollectionModel()
        let results = ResultsModel()
        
        
        let firstTest = Int(home.seasonYear ?? "error unwrapping seasonYear") ?? 0
        XCTAssertEqual(firstTest, 0)
    }
            
  

}
