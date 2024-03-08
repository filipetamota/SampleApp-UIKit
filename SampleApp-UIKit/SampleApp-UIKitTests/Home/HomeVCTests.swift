//
//  HomeVCTests.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 8/3/24.
//

import XCTest

final class HomeVCTests: XCTestCase {
    var sut: HomeViewController!

    override func setUpWithError() throws {
        setupViewController()
    }

    func testHomeVC() throws {
        sut.currentPage = 4
        sut.display(totalResults: 1, totalPages: 10, viewModel: Home.Fetch.ViewModel(results: [SearchResult(photoId: "abc123", alt_description: "dog running", likes: 123, thumbUrl: "", userName: "Test User")], error: nil))
        XCTAssertEqual(sut.totalResults, 1)
        XCTAssertEqual(sut.totalPages, 10)
        XCTAssertEqual(sut.tableContent.count, 1)
        XCTAssertEqual(sut.currentPage, 5)
    }
    
    func setupViewController() {
        sut = HomeViewController()
    }

}
