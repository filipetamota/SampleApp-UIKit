//
//  HomeInteractorTests.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 8/3/24.
//

import XCTest

final class HomeInteractorTests: XCTestCase {
    var sut: HomeInteractor!
    var workerSpy: HomeWorkerSpy!
    
    override func setUpWithError() throws {
        
        // GIVEN
        setupInteractor()
        setupWorker()
        XCTAssertNotNil(sut.worker)
    }

    func testHomeInteractor() throws {
        let expectation = self.expectation(description: "HomeInteractor_Fetch")
        var responseResult: Home.Fetch.Response!
        
        // WHEN
        let mockRequest = Home.Fetch.Request(query: "dog", page: 1, data: .search)
        sut.worker!.fetch(request: mockRequest, completion: { result in
            switch result {
            case .success(let response):
                responseResult = response
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed with error \(error)")
            }
        })
        
        waitForExpectations(timeout: 5, handler: nil)

        // THEN
        XCTAssertEqual(responseResult.total, 100)
        XCTAssertEqual(responseResult.total_pages, 10)
        XCTAssertEqual(responseResult.results.count, 1)
        XCTAssertEqual(responseResult.results.first!.photoId, "yihlaRCCvd4")
    }
    
    func testHomeInteractorWithError() throws {
        let expectation = self.expectation(description: "HomeInteractor_FetchWithError")
        var errorResult: URLError!
        
        // WHEN
        let errorRequest = Home.Fetch.Request(query: "error", page: 1, data: .search)
        sut.worker!.fetch(request: errorRequest, completion: { result in
            switch result {
            case .success:
                XCTFail("Shouldn't enter here")
            case .failure(let error):
                errorResult = error
                expectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // THEN
        XCTAssertEqual(errorResult, URLError(.badServerResponse))
    }
    
    func setupInteractor() {
        sut = HomeInteractor()
    }
    
    func setupWorker() {
        workerSpy = HomeWorkerSpy()
        sut.worker = workerSpy
    }

}

extension HomeInteractorTests {
    class HomeWorkerSpy: HomeWorker {
        
        override func fetch(request: Home.Fetch.Request, completion: @escaping (Result<Home.Fetch.Response, URLError>) -> Void) {
            if request.query == "error" {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            if let url = Bundle.main.url(forResource: "search_response", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    
                    let searchResponse = try JSONDecoder().decode(Home.Fetch.Response.self, from: data)
                    completion(.success(searchResponse))
                } catch {
                    completion(.failure(URLError(.unknown)))
                }
            } else {
                completion(.failure(URLError(.badURL)))
            }
        }
    }
}
