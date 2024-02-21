//
//  DetailInteractor.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

protocol DetailBusinessLogic {
    func fetch()
    func addRemoveFavorite(favorite: DetailResult, completion: @escaping (Result<FavoriteOperation, SampleAppError>) -> Void)
    func isFavorite(photoId: String) -> Bool
}

protocol DetailDataStore {
    var photoId: String { get set }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore {
    
    var photoId: String = ""
    var presenter: DetailPresentationLogic?
    var worker: DetailWorker?
    var favoritesWorker: FavoritesWorker?
    
    func fetch() {
        favoritesWorker = FavoritesWorker()
        if 
            favoritesWorker?.isFavorite(photoId: photoId) ?? false,
            let favorites = try? favoritesWorker?.getFavorite(photoId: photoId),
            favorites.count == 1
        {
            self.presenter?.present(savedFavorite: favorites.first!)
        } else {
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
    
    func addRemoveFavorite(favorite: DetailResult, completion: @escaping (Result<FavoriteOperation, SampleAppError>) -> Void) {
        if isFavorite(photoId: favorite.id) {
            deleteFavorite(photoId: favorite.id, completion: completion)
        } else {
            addFavorite(favorite: favorite, completion: completion)
        }
    }
    
    private func addFavorite(favorite: DetailResult, completion: @escaping (Result<FavoriteOperation, SampleAppError>) -> Void) {
        favoritesWorker = FavoritesWorker()
        favoritesWorker?.saveFavorite(favorite: favorite, completion: completion)
    }
    
    private func deleteFavorite(photoId: String, completion: @escaping (Result<FavoriteOperation, SampleAppError>) -> Void) {
        favoritesWorker = FavoritesWorker()
        favoritesWorker?.deleteFavorite(photoId: photoId, completion: completion)
    }
    
    func isFavorite(photoId: String) -> Bool {
        favoritesWorker = FavoritesWorker()
        return favoritesWorker?.isFavorite(photoId: photoId) ?? false
    }
}
