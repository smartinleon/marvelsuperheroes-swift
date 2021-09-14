//
//  mobile_testTests.swift
//  mobile-testTests
//
//  Created by sergio.martin.leon on 19/05/2021.
//

import XCTest
@testable import mobile_test

class mobile_testTests: XCTestCase {
    
    //API
    func testSheroes() throws {
        let expectation = self.expectation(description: "Retrieved the first 10 superheroes")
        
        var sheroes: [SuperheroEntity]?

        APIClient.shared.externalGetData() { (data, success) in
            sheroes = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20){ (sh) in
            XCTAssertEqual(sheroes?.count, 10)
        }
    }
    
    func testSheroesOffset() throws {
        let expectation = self.expectation(description: "Retrieved the second 10 superheroes")
        
        var sheroes: [SuperheroEntity]?

        APIClient.shared.externalGetData(offset: 11) { (data, success) in
            sheroes = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20){ (sh) in
            XCTAssertEqual(sheroes?.count, 10)
        }
    }
    
    func testSheroSearchedByName() throws {
        let expectation = self.expectation(description: "Retrieved 'Thanos' results")
        let text = "thanos"
        var sheroes: [SuperheroEntity]?

        APIClient.shared.externalGetData(text: text) { (data, success) in
            sheroes = data
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20){ (sh) in
            XCTAssertEqual(sheroes?.first?.name, "Thanos")
        }
    }
    
    func testDetailShero() throws {
        let expectation = self.expectation(description: "Retrieved the superhero with id 1011334")
        
        var shero: SuperheroEntity?

        APIClient.shared.externalGetData(id: 1011334) { (data, success) in
            shero = data?.first
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20){ (sh) in
           XCTAssertNotNil(shero)
        }
    }
    
    func testSheroShowNoDataMessageError() throws {
        let expectation = self.expectation(description: "No values message")
        
        var sheroes = [SuperheroEntity]()

        APIClient.shared.externalGetData(text: "this is an example of no values") { (data, success) in

            guard let d = data else {
              return expectation.fulfill()
            }

            sheroes = d
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20){ (sh) in
            XCTAssertEqual(sheroes.count, 0)
        }
    }
    
    func testSheroImageData() throws {
        let expectation = self.expectation(description: "Image data of superhero 1011334")
        
        var shero: SuperheroEntity?
        var imageData: Data?

        APIClient.shared.externalGetData(id: 1011334) { (data, success) in
            shero = data?.first

            guard let superhero = shero else {
                return XCTAssertNil(shero)
            }

            APIClient.shared.externalGetSHeroImageData(shero: superhero) { (data, successImageData) in
                imageData = data
                
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 20){ (sh) in
            XCTAssertNotEqual(imageData, nil)
        }
    }
    
    func testOrderedSheroes() throws {
        let expectation = self.expectation(description: "Order the first 10 superheroes")
        
        var sheroes: [SuperheroEntity]?
        var sheroesOrdered: [SuperheroEntity]?

        APIClient.shared.externalGetData() { (data, success) in
            sheroes = data
            sheroesOrdered = data

            guard let superheroesOrdered = sheroesOrdered else {
                return XCTAssertNil(sheroesOrdered)
            }

            //Order descendent
            let presenter = MainListPresenter()
            sheroesOrdered = presenter.orderData(data: superheroesOrdered, ordering: .orderedDescending)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20){ (sh) in
            XCTAssertNotEqual(sheroes?.first?.id, sheroesOrdered?.first?.id)
        }
    }
}
