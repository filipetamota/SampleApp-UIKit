//
//  HomeRouterTests.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 8/3/24.
//

import XCTest

final class HomeRouterTests: XCTestCase {
    var sut: HomeRouterSpy!

    func testRouterToDetail() throws {
        // GIVEN
        setupRouter()
        let sourceVC = HomeViewController()
        let sourceInteractor = HomeInteractor()
        sourceInteractor.photoId = "abc123"
        sut.dataStore = sourceInteractor
        
        // WHEN
        sut.routeToDetail(source: sourceVC)
        
        // THEN
        XCTAssertTrue(sut.didNavigate)
        XCTAssertTrue(sut.didPassData)
    }

    func setupRouter() {
        sut = HomeRouterSpy()
    }
}

extension HomeRouterTests {
    class HomeRouterSpy: HomeRouter {
        var didNavigate = false
        var didPassData = false
        
        override func navigateToDetail(source: HomeViewController, destination: DetailViewController) {
            didNavigate = true
        }
        
        override func passDataToDetail(source: HomeDataStore, destination: inout DetailDataStore) {
            XCTAssertEqual(source.photoId, "abc123")
            didPassData = true
        }
    }
}
