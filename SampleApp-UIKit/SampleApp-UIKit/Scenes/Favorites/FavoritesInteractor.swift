//
//  FavoritesInteractor.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 21/2/24.
//

import UIKit

protocol FavoritesBusinessLogic {
    func fetch()
    func removeFavorite(favId: String)
}

protocol FavoritesDataStore {
    var favId: String { get set }
}

final class FavoritesInteractor: FavoritesBusinessLogic, FavoritesDataStore {
    var favId: String = ""
    var presenter: FavoritesPresentationLogic?
    var worker: FavoritesWorker?
    typealias Response = Favorites.Fetch.Response
  
    func fetch() {
        do {
            let favorites = try worker?.getAllFavorites()
            guard let favorites = favorites else {
                self.presenter?.presentError(error: .modelError)
                return
            }
            self.presenter?.presentResults(response: Response(results: favorites))
        } catch {
            self.presenter?.presentError(error: .modelError)
        }
    }
    
    func removeFavorite(favId: String) {
        worker?.deleteFavorite(photoId: favId, completion: { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.presentDeleteSuccess()
            case .failure(let error):
                self?.presenter?.presentError(error: error)
            }
        })
    }
}
