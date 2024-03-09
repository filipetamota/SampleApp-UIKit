//
//  FavoritesRouter.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 21/2/24.
//

import UIKit

protocol FavoritesRoutingLogic {
    func routeToDetail(source: FavoritesViewController)
}

protocol FavoritesDataPassing {
    var dataStore: FavoritesDataStore? { get }
}

class FavoritesRouter: NSObject, FavoritesRoutingLogic, FavoritesDataPassing {
    weak var viewController: FavoritesViewController?
    var dataStore: FavoritesDataStore?

    // MARK: Routing
    
    func routeToDetail(source: FavoritesViewController) {
        let destinationVC = DetailViewController()
        guard var destinationDS = destinationVC.router?.dataStore else { return }
        passDataToDetail(source: dataStore!, destination: &destinationDS)
        navigateToDetail(source: source, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToDetail(source: FavoritesViewController, destination: DetailViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToDetail(source: FavoritesDataStore, destination: inout DetailDataStore) {
        destination.photoId = source.favId
    }
    
}
