//
//  DetailInteractor.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

protocol DetailBusinessLogic {
    func fetch()
}

protocol DetailDataStore {
    var photoId: String { get set }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore {
    var photoId: String = ""
    var presenter: DetailPresentationLogic?
    var worker: DetailWorker?
    
    func fetch() {
        worker = DetailWorker()
        worker?.fetch(request: Detail.Fetch.Request(photoId: photoId, data: .get), completion: { result in
            switch result {
            case .success(let response):
                self.presenter?.present(response: response)
            case .failure(let error):
                self.presenter?.present(error: error)
            }
        })
    }
}
