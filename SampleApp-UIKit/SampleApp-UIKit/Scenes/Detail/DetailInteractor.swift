//
//  DetailInteractor.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

protocol DetailBusinessLogic {
    func fetch()
    func addRemoveFavorite(favorite: DetailResult, completion: @escaping (Result<FavoriteOperation, ModelError>) -> Void)
    func isFavorite(photoId: String) -> Bool
}

protocol DetailDataStore {
    var photoId: String { get set }
}

final class DetailInteractor: DetailBusinessLogic, DetailDataStore {
    var photoId: String = ""
    var presenter: DetailPresentationLogic?
    var worker: DetailWorker?
    var favoritesWorker: FavoritesWorker?
    
    
    func fetch() {
        setupFavoritesWorker()
        if 
            favoritesWorker?.isFavorite(photoId: photoId) ?? false,
            let favorite = try? favoritesWorker?.getFavorite(photoId: photoId)
        {
            self.presenter?.present(savedFavorite: favorite)
        } else {
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
    
    func addRemoveFavorite(favorite: DetailResult, completion: @escaping (Result<FavoriteOperation, ModelError>) -> Void) {
        if isFavorite(photoId: favorite.id) {
            deleteFavorite(photoId: favorite.id, completion: completion)
        } else {
            addFavorite(favorite: favorite, completion: completion)
        }
    }
    
    private func addFavorite(favorite: DetailResult, completion: @escaping (Result<FavoriteOperation, ModelError>) -> Void) {
        setupFavoritesWorker()
        favoritesWorker?.saveFavorite(favorite: favorite, completion: completion)
    }
    
    private func deleteFavorite(photoId: String, completion: @escaping (Result<FavoriteOperation, ModelError>) -> Void) {
        setupFavoritesWorker()
        favoritesWorker?.deleteFavorite(photoId: photoId, completion: completion)
    }
    
    func isFavorite(photoId: String) -> Bool {
        setupFavoritesWorker()
        return favoritesWorker?.isFavorite(photoId: photoId) ?? false
    }
    
    private func setupFavoritesWorker() {
        favoritesWorker = FavoritesWorker()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure("Shouldn't enter here")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        favoritesWorker?.context = managedContext
    }
}
