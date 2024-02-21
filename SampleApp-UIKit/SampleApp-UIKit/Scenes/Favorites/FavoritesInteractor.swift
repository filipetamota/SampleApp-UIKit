//
//  FavoritesInteractor.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 21/2/24.
//

import UIKit

protocol FavoritesBusinessLogic {
    func fetch()
}

final class FavoritesInteractor: FavoritesBusinessLogic {
    var presenter: FavoritesPresentationLogic?
    var worker: FavoritesWorker?
    typealias Response = Favorites.Fetch.Response
  
    func fetch() {
        worker = FavoritesWorker()
        do {
            let favorites = try worker?.getAllFavorites()
            guard let favorites = favorites else {
                self.presenter?.present(error: .modelError)
                return
            }
            self.presenter?.present(response: Response(results: favorites))
        } catch {
            self.presenter?.present(error: .modelError)
        }
    }
}
