//
//  HomePresenterTests.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 8/3/24.
//

import XCTest
@testable import SampleApp_UIKit

final class HomePresenterTests: XCTestCase {
    var sut: HomePresenter!

    func testHomePresenter() throws {
        // GIVEN
        setupPresenter()
        let vc = HomeDisplayLogicSpy()
        sut.viewController = vc
        
        // WHEN
        let response = Home.Fetch.Response(total: 10, total_pages: 1, results: [ResponseResult(photoId: "abc1234", alt_description: "dog running", likes: 456, urls: HomeUrls(thumb: ""), user: HomeUser(name: "Test User"))])
        sut.present(response: response)
    }
    
    func testHomePresenterWithError() throws {
        // GIVEN
        setupPresenter()
        let vc = HomeDisplayLogicSpy()
        vc.showError = true
        sut.viewController = vc
        
        // WHEN
        sut.present(error: URLError(.badServerResponse))
    }

    func setupPresenter() {
        sut = HomePresenter()
    }
}


extension HomePresenterTests {
    class HomeDisplayLogicSpy: HomeDisplayLogic {
        var showError: Bool = false
        
        func display(totalResults: Int, totalPages: Int, viewModel: Home.Fetch.ViewModel) {
            // THEN
            if showError {
                XCTAssertEqual(totalResults, 0)
                XCTAssertEqual(totalPages, 0)
                XCTAssertNil(viewModel.results)
                XCTAssertEqual(viewModel.error, URLError(.badServerResponse))
            } else {
                XCTAssertEqual(totalResults, 10)
                XCTAssertEqual(totalPages, 1)
                XCTAssertNotNil(viewModel.results)
                XCTAssertEqual(viewModel.results!.count, 1)
                XCTAssertEqual(viewModel.results!.first!.photoId, "abc1234")
            }
        }
    }
}
