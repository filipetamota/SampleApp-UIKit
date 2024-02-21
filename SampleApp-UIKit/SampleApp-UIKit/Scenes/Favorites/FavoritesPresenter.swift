//
//  FavoritesPresenter.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 21/2/24.
//

import UIKit

protocol FavoritesPresentationLogic {
    func present(response: Favorites.Fetch.Response)
    func present(error: SampleAppError)
}

final class FavoritesPresenter: FavoritesPresentationLogic {
    weak var viewController: FavoritesDisplayLogic?
    typealias ViewModel = Favorites.Fetch.ViewModel
  
    func present(response: Favorites.Fetch.Response) {
        let viewModel = ViewModel(results: response.results, error: nil)
        viewController?.display(viewModel: viewModel)
    }
    
    func present(error: SampleAppError) {
        let viewModel = ViewModel(results: nil, error: error)
        viewController?.display(viewModel: viewModel)
    }
}
