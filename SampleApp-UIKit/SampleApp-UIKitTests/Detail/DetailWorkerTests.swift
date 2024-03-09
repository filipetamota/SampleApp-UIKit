//
//  DetailWorkerTests.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 8/3/24.
//

import XCTest
@testable import SampleApp_UIKit

final class DetailWorkerTests: XCTestCase {
    var sut: DetailWorker!

    func testDetailWorker() throws {
        let expectation = self.expectation(description: "DetailWorker_Fetch")
        
        // GIVEN
        setupWorker()
        
        // WHEN
        let mockRequest = Detail.Fetch.Request(photoId: "abc123", data: .get)
        sut.fetch(request: mockRequest) { result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        
        // THEN
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDetailWorkerWithError() throws {
        let expectation = self.expectation(description: "DetailWorker_FetchWithError")
        
        // GIVEN
        setupWorker(showError: true)
        
        // WHEN
        let mockRequest = Detail.Fetch.Request(photoId: "abc123", data: .get)
        sut.fetch(request: mockRequest) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                expectation.fulfill()
            }
        }
        
        // THEN
        waitForExpectations(timeout: 5, handler: nil)
    }

    func setupWorker(showError: Bool = false) {
        sut = AppDetailWorker()
        let apiClient = APIClientSpy()
        apiClient.showError = showError
        sut.apiClient = apiClient
    }

}

extension DetailWorkerTests {
    class APIClientSpy: APIClient {
        var showError: Bool = false

        func send(request: URLRequest) async throws -> Data {
            if
                !showError,
                let url = Bundle.main.url(forResource: "get_photo", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    return data
                } catch let e {
                    throw e
                }
                
                
            }
            throw NSError()
        }
    }
}
