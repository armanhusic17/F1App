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


    
    // Change year to any year from 1950 to Present - Test Passes Successfully retrieves data
    func testWorldDriversChampionshipStandingsForAllYears() {
        for year in 1999...2000 {
            let expectation = XCTestExpectation(description: "Data loaded successfully for \(year)")

            // Clear cache for the specific year
            UserDefaults.standard.removeObject(forKey: "cache_worldDriversChampionshipStandings_\(year)")

            F1ApiRoutes.worldDriversChampionshipStandings(seasonYear: "\(year)") { success in
                XCTAssertTrue(success, "Data should load successfully for \(year)")
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 5.0) // Adjust timeout if needed
        }
    }
    
    



}
