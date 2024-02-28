//
//  FavoritesPresenter.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 21/2/24.
//

import UIKit

protocol FavoritesPresentationLogic {
    func presentResults(response: Favorites.Fetch.Response)
    func presentDeleteSuccess()
    func presentError(error: ModelError)
}

final class FavoritesPresenter: FavoritesPresentationLogic {
    weak var viewController: FavoritesDisplayLogic?
    typealias ViewModel = Favorites.Fetch.ViewModel
  
    func presentResults(response: Favorites.Fetch.Response) {
        let viewModel = ViewModel(results: response.results, error: nil)
        viewController?.display(viewModel: viewModel)
    }
    
    func presentDeleteSuccess() {
        let viewModel = ViewModel(results: nil, error: nil)
        viewController?.display(viewModel: viewModel)
    }
    
    func presentError(error: ModelError) {
        let viewModel = ViewModel(results: nil, error: error)
        viewController?.display(viewModel: viewModel)
    }
}
