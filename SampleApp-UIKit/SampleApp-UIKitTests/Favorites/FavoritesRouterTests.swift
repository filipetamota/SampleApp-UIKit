//
//  FavoritesRouterTests.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 8/3/24.
//

import XCTest
@testable import SampleApp_UIKit

final class FavoritesRouterTests: XCTestCase {
    var sut: FavoritesRouterSpy?
    
    override func setUpWithError() throws {
        // GIVEN
        sut = FavoritesRouterSpy()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }

    func testRouterToDetail() throws {
        // GIVEN
        let sourceVC = FavoritesViewController()
        let sourceInteractor = FavoritesInteractor()
        sourceInteractor.favId = "abc123"
        sut?.dataStore = sourceInteractor
        
        // WHEN
        sut?.routeToDetail(source: sourceVC)
        
        // THEN
        XCTAssertTrue(sut?.didNavigate ?? false)
        XCTAssertTrue(sut?.didPassData ?? false)
    }
}

extension FavoritesRouterTests {
    class FavoritesRouterSpy: FavoritesRouter {
        var didNavigate = false
        var didPassData = false
        
        override func navigateToDetail(source: FavoritesViewController, destination: DetailViewController) {
            didNavigate = true
        }
        
        override func passDataToDetail(source: FavoritesDataStore, destination: inout DetailDataStore) {
            XCTAssertEqual(source.favId, "abc123")
            didPassData = true
        }
    }
}
