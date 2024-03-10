//
//  HomeInteractorTests.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 8/3/24.
//

import XCTest
@testable import SampleApp_UIKit

final class HomeInteractorTests: XCTestCase {
    var sut: HomeInteractor?
    var workerSpy: HomeWorkerSpy?
    var presenterSpy: HomePresentationLogic?
    
    override func setUpWithError() throws {
        // GIVEN
        sut = HomeInteractor()
        workerSpy = HomeWorkerSpy()
        sut?.worker = workerSpy
        presenterSpy = HomePresenterSpy()
        sut?.presenter = presenterSpy
        XCTAssertNotNil(sut?.worker)
        XCTAssertNotNil(sut?.presenter)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        workerSpy = nil
        presenterSpy = nil
    }

    func testHomeInteractor() throws {
        // WHEN
        sut?.fetch(query: "dog", page: 1)
    }
    
    func testHomeInteractorWithError() throws {
        // WHEN
        sut?.fetch(query: "error", page: 1)
    }
}

extension HomeInteractorTests {
    class HomeWorkerSpy: HomeWorker {
        var apiClient: APIClient!
        
        func fetch(request: Home.Fetch.Request, completion: @escaping (Result<Home.Fetch.Response, URLError>) -> Void) {
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
    
    class HomePresenterSpy: HomePresentationLogic {
        func present(response: Home.Fetch.Response) {
            // THEN
            XCTAssertEqual(response.total, 100)
            XCTAssertEqual(response.total_pages, 10)
            XCTAssertEqual(response.results.count, 1)
            XCTAssertEqual(response.results.first!.photoId, "yihlaRCCvd4")
        }
        
        func present(error: URLError) {
            // THEN
            XCTAssertEqual(error, URLError(.badServerResponse))
        }
    }
}
