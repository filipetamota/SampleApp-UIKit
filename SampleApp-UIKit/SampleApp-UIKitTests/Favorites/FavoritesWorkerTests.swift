//
//  FavoritesWorkerTests.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 8/3/24.
//

import XCTest
@testable import SampleApp_UIKit

final class FavoritesWorkerTests: XCTestCase {
    var sut: FavoritesWorker?
    var context = MockPersistentStoreContainer().viewContext
    
    override func setUpWithError() throws {
        // GIVEN
        sut = FavoritesWorker()
        sut?.context = context
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }

    func testSaveFavorite() throws {
        let expectation = self.expectation(description: "FavoritesWorker_Save")

        // WHEN
        addMockFavoriteToContext(worker: sut, expectation: expectation)
        
        // THEN
        waitForExpectations(timeout: 5, handler: nil)
        let favorites = try sut?.getAllFavorites() ?? []
        XCTAssertEqual(favorites.count, 1)
        let favorite = try sut?.getFavorite(photoId: "abc1234")
        XCTAssertNotNil(favorite)
        XCTAssertEqual(favorite!.likes, 567)
        XCTAssertEqual(favorite!.location, "Coimbra, Portugal")
    }
    
    func testDeleteFavorite() throws {
        let saveExpectation = self.expectation(description: "FavoritesWorker_Save")
        let deleteExpectation = self.expectation(description: "FavoritesWorker_Delete")

        // WHEN
        addMockFavoriteToContext(worker: sut, expectation: saveExpectation)
        sut?.deleteFavorite(photoId: "abc1234") { result in
            switch result {
            case .success(let operation):
                XCTAssertEqual(operation, .remove)
                deleteExpectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        
        // THEN
        waitForExpectations(timeout: 5, handler: nil)
        let favorites = try sut?.getAllFavorites() ?? []
        XCTAssertEqual(favorites.count, 0)
    }
    
    func testIsFavoriteAndGetFavorites() throws {
        let saveExpectation = self.expectation(description: "FavoritesWorker_Save")
        
        // WHEN
        addMockFavoriteToContext(worker: sut, expectation: saveExpectation)
        
        // THEN
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(sut?.isFavorite(photoId: "abc1234") ?? false)
        XCTAssertEqual(try sut?.getAllFavorites().count, 1)
        XCTAssertNotNil(try sut?.getFavorite(photoId: "abc1234"))
    }
    

}
