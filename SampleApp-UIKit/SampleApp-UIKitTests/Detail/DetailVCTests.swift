//
//  DetailVCTests.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 8/3/24.
//

import XCTest
@testable import SampleApp_UIKit

final class DetailVCTests: XCTestCase {
    var sut: DetailViewController?

    override func setUpWithError() throws {
        // GIVEN
        sut = DetailViewController()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }

    func testDetailVC() throws {
        // WHEN
        XCTAssertNotNil(sut)
        sut?.display(viewModel: Detail.Fetch.ViewModel(result: DetailResult(id: "abc123", width: 100, height: 100, alt_description: nil, description: nil, likes: 678, imgUrl: "", thumbUrl: "", userName: "Test User", equipment: "NIKON D70", location: "London, UK"), error: nil))
        
        // THEN
        XCTAssertNotNil(sut?.currentResult)
        XCTAssertEqual(sut?.currentResult?.id, "abc123")
        XCTAssertEqual(sut?.currentResult?.equipment, "NIKON D70")
        XCTAssertEqual(sut?.currentResult?.location, "London, UK")
    }

}
