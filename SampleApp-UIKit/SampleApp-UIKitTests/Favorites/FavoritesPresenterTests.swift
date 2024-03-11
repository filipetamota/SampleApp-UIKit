//
//  FavoritesPresenterTests.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 8/3/24.
//

import XCTest
@testable import SampleApp_UIKit

final class FavoritesPresenterTests: XCTestCase {
    var sut: FavoritesPresenter?
    var vcSpy: FavoritesDisplayLogicSpy?
    var context = MockPersistentStoreContainer().viewContext
    
    override func setUpWithError() throws {
        // GIVEN
        sut = FavoritesPresenter()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        vcSpy = nil
    }

    func testFavoritesPresenter() throws {
        let saveExpectation = self.expectation(description: "FavoritesPresenter_Save")
        
        // GIVEN
        let vc = FavoritesDisplayLogicSpy()
        vc.showError = false
        sut?.viewController = vc
        vcSpy = vc

        let worker = FavoritesWorker()
        worker.context = context
        addMockFavoriteToContext(worker: worker, expectation: saveExpectation)
        guard let favorite = try worker.getFavorite(photoId: "abc1234") else {
            XCTFail()
            return
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // WHEN
        sut?.presentResults(response: Favorites.Fetch.Response(results: [favorite]))
    }
    
    func testFavoritesPresenterWithError() throws {
        // GIVEN
        let vc = FavoritesDisplayLogicSpy()
        vc.showError = true
        sut?.viewController = vc
        vcSpy = vc

        let worker = FavoritesWorker()
        worker.context = context
        
        // WHEN
        sut?.presentError(error: .modelError)
    }
}

extension FavoritesPresenterTests {
    class FavoritesDisplayLogicSpy: FavoritesDisplayLogic {
        var showError: Bool = false
        
        func display(viewModel: Favorites.Fetch.ViewModel) {
            // THEN
            if showError {
                XCTAssertNil(viewModel.results)
                XCTAssertNotNil(viewModel.error)
                XCTAssertEqual(viewModel.error, .modelError)
            } else {
                XCTAssertNotNil(viewModel.results)
                XCTAssertEqual(viewModel.results!.count, 1)
                XCTAssertEqual(viewModel.results!.first!.favId, "abc1234")
                XCTAssertEqual(viewModel.results!.first!.userName, "Test User")
                XCTAssertEqual(viewModel.results!.first!.likes, 567)
                XCTAssertEqual(viewModel.results!.first!.equipment, "NIKON D70")
            }
        }
    }
}

