//
//  HomeRouter.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

protocol HomeRoutingLogic {
    func routeToDetail(source: HomeViewController)
    func routeToFavorites(source: HomeViewController)
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
    
    // MARK: Routing
    
    func routeToDetail(source: HomeViewController) {
        let destinationVC = DetailViewController()
        guard var destinationDS = destinationVC.router?.dataStore else { return }
        passDataToDetail(source: dataStore!, destination: &destinationDS)
        navigateToDetail(source: source, destination: destinationVC)
    }
    
    func routeToFavorites(source: HomeViewController) {
        let destinationVC = FavoritesViewController()
        navigateToFavorites(source: source, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToDetail(source: HomeViewController, destination: DetailViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToFavorites(source: HomeViewController, destination: FavoritesViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToDetail(source: HomeDataStore, destination: inout DetailDataStore) {
        destination.photoId = source.photoId
    }
}
