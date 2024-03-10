//
//  XCTestCase.swift
//  SampleApp-UIKitTests
//
//  Created by Filipe Mota on 9/3/24.
//

import XCTest
import CoreData
@testable import SampleApp_UIKit

extension XCTestCase {
    
    class MockPersistentStoreContainer: NSPersistentContainer {
        
        init() {
            let modelUrl = Bundle.main.url(forResource: "DataModel", withExtension: "momd")!
            let managedObjectModel = NSManagedObjectModel.init(contentsOf: modelUrl)!
            super.init(name: "DataModel", managedObjectModel: managedObjectModel)
            
            let description = NSPersistentStoreDescription.init()
            description.type = NSInMemoryStoreType
            persistentStoreDescriptions = [description]
            loadPersistentStores(completionHandler: { (persistentStore, error) in
                if let error = error as? NSError {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
        }
    }
    
    func addFavoriteToContext(worker: FavoritesWorker, expectation: XCTestExpectation) {
        worker.saveFavorite(favorite: DetailResult(id: "abc1234", width: 100, height: 100, alt_description: "", description: "", likes: 567, imgUrl: "", thumbUrl: "", userName: "Test User", equipment: "NIKON D70", location: "Coimbra, Portugal")) { result in
            switch result {
            case .success(let operation):
                XCTAssertEqual(operation, .add)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
    }
}
