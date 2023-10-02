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
            
  
    func testHomeViewController() {
        let home = HomeCollection()
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
    }
    
    func testWorldDriversChampionshipStandings() {
        let expectation = XCTestExpectation(description: "Data loaded successfully")

        F1ApiRoutes.worldDriversChampionshipStandings(seasonYear: "2023") { success in
            XCTAssertTrue(success, "Data should load successfully")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0) // Adjust timeout if needed
    }

}
