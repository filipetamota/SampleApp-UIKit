//
//  HomeWorkerTests.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 8/3/24.
//

import XCTest

final class HomeWorkerTests: XCTestCase {
    var sut: HomeWorker!

    func testHomeWorker() throws {
        let expectation = self.expectation(description: "HomeWorker_Fetch")
        
        // GIVEN
        setupWorker()
        
        // WHEN
        let mockRequest = Home.Fetch.Request(query: "dog", page: 1, data: .search)
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
    
    func testHomeWorkerWithError() throws {
        let expectation = self.expectation(description: "HomeWorker_FetchWithError")
        
        // GIVEN
        setupWorker(showError: true)
        
        // WHEN
        let mockRequest = Home.Fetch.Request(query: "dog", page: 1, data: .search)
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
        sut = HomeWorker()
        let apiClient = APIClientSpy()
        apiClient.showError = showError
        sut.apiClient = apiClient
    }

}

extension HomeWorkerTests {
    class APIClientSpy: APIClient {
        var showError: Bool = false

        override func send(request: URLRequest) async throws -> Data {
            if
                !showError,
                let url = Bundle.main.url(forResource: "search_response", withExtension: "json") {
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
