//
//  DetailInteractorTests.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 8/3/24.
//

import XCTest
@testable import SampleApp_UIKit

final class DetailInteractorTests: XCTestCase {
    var sut: DetailInteractor?
    var workerSpy: DetailWorkerSpy?
    var presenterSpy: DetailPresentationLogic?
    
    override func setUpWithError() throws {
        
        // GIVEN
        sut = DetailInteractor()
        workerSpy = DetailWorkerSpy()
        presenterSpy = DetailPresenterSpy()
        sut?.worker = workerSpy
        sut?.presenter = presenterSpy
        XCTAssertNotNil(sut?.worker)
        XCTAssertNotNil(sut?.presenter)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        workerSpy = nil
        presenterSpy = nil
    }

    func testDetailInteractor() throws {
        // WHEN
        sut?.photoId = "yihlaRCCvd4"
        sut?.fetch()
    }
    
    func testDetailInteractorWithError() throws {
        // WHEN
        sut?.photoId = "error"
        sut?.fetch()
    }

    func setupInteractor() {

    }
}

extension DetailInteractorTests {
    class DetailWorkerSpy: DetailWorker {
        
        override func fetch(request: Detail.Fetch.Request, completion: @escaping (Result<Detail.Fetch.Response, URLError>) -> Void) {
            if request.photoId == "error" {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            if let url = Bundle.main.url(forResource: "get_photo", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    
                    let photoResponse = try JSONDecoder().decode(Detail.Fetch.Response.self, from: data)
                    completion(.success(photoResponse))
                } catch {
                    completion(.failure(URLError(.unknown)))
                }
            } else {
                completion(.failure(URLError(.badURL)))
            }
        }
    }
    
    class DetailPresenterSpy: DetailPresentationLogic {
        func present(response: Detail.Fetch.Response) {
            // THEN
            XCTAssertEqual(response.id, "yihlaRCCvd4")
            XCTAssertEqual(response.width, 4016)
            XCTAssertNotNil(response.alt_description)
            XCTAssertEqual(response.user.name, "Oscar Sutton")
            XCTAssertEqual(response.exif!.model, "NIKON D750")
        }
        
        func present(savedFavorite: FavoriteItem) {
            fatalError()
        }
        
        func present(error: Error) {
            // THEN
            XCTAssertNotNil(error)
        }
    }
}
