//
//  HomePresenter.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

protocol HomePresentationLogic {
    func present(response: Home.Fetch.Response)
    func present(error: Error)
}

final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
  
    func present(response: Home.Fetch.Response) {
        let viewModel = Home.Fetch.ViewModel(results: response.results, error: nil)
        viewController?.display(totalResults: response.total, totalPages: response.total_pages, viewModel: viewModel)
    }
    
    func present(error: Error) {
        let viewModel = Home.Fetch.ViewModel(results: nil, error: error)
        viewController?.display(totalResults: 0, totalPages: 0, viewModel: viewModel)
    }
}
