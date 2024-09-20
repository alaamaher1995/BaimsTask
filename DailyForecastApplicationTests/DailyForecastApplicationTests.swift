//
//  DailyForecastApplicationTests.swift
//  DailyForecastApplicationTests
//
//  Created by New User on 18/09/2024.
//

import XCTest
@testable import DailyForecastApplication

final class DailyForecastApplicationTests: XCTestCase {

    func testWeatherAPIClient() {
        let expectation = self.expectation(description: "Fetching weather data")
            
        WeatherAPIClient().fetchWeather(for: 51.5074, longitude: -0.1278) { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 5, handler: nil)
    }
   
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
