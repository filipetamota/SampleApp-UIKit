//
//  DetailPresenterTests.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 8/3/24.
//

import XCTest
@testable import SampleApp_UIKit

final class DetailPresenterTests: XCTestCase {
    var sut: DetailPresenter?
    
    override func setUpWithError() throws {
        // GIVEN
        sut = DetailPresenter()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }

    func testDetailPresenter() throws {
        // GIVEN
        let vc = DetailDisplayLogicSpy()
        sut?.viewController = vc
        
        // WHEN
        let response = Detail.Fetch.Response(id: "yihlaRCCvd4", width: 100, height: 100, alt_description: nil, description: nil, likes: 1913, urls: DetailUrls(regular: "", thumb: ""), user: DetailUser(id: "", username: "", name: ""), exif: nil, location: Location(name: "Pagham, UK"))
        sut?.present(response: response)
    }
    
    func testDetailPresenterWithError() throws {
        // GIVEN
        let vc = DetailDisplayLogicSpy()
        vc.showError = true
        sut?.viewController = vc
        
        // WHEN
        sut?.present(error: URLError(.badServerResponse))
    }

}

extension DetailPresenterTests {
    class DetailDisplayLogicSpy: DetailDisplayLogic {
        var showError: Bool = false
        
        func display(viewModel: Detail.Fetch.ViewModel) {
            // THEN
            if showError {
                XCTAssertNotNil(viewModel.error)
                XCTAssertNil(viewModel.result)
            } else {
                XCTAssertNotNil(viewModel.result)
                XCTAssertEqual(viewModel.result?.id, "yihlaRCCvd4")
                XCTAssertEqual(viewModel.result?.likes, 1913)
                XCTAssertEqual(viewModel.result?.location, "Pagham, UK")
            }
        }
    }
}
