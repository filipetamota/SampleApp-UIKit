//
//  HomeInteractor.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

protocol HomeBusinessLogic {
    func fetch(query: String)
}

protocol HomeDataStore {
    var photoId: String { get set }
}

final class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    var photoId: String = ""
    var presenter: HomePresentationLogic?
    var worker: HomeWorker?
    typealias Request = Home.Fetch.Request
  
    func fetch(query: String) {
        
        worker = HomeWorker()
        
        worker?.fetch(request: Request(query: query, data: .search), completion: { result in
            switch result {
            case .success(let response):
                self.presenter?.present(response: response)
            case .failure(let error):
                self.presenter?.present(error: error)
            }
        })
        
        
    }
}
