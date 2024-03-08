//
//  HomePresenter.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

protocol HomePresentationLogic {
    func present(response: Home.Fetch.Response)
    func present(error: URLError)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
  
    func present(response: Home.Fetch.Response) {
        var searchResults: [SearchResult] = []
        
        for result in response.results {
            searchResults.append(SearchResult(photoId: result.photoId,
                                              alt_description: result.alt_description,
                                              likes: result.likes,
                                              thumbUrl: result.urls.thumb,
                                              userName: result.user.name))
        }
        
        viewController?.display(totalResults: response.total, totalPages: response.total_pages, viewModel: Home.Fetch.ViewModel(results: searchResults, error: nil))
    }
    
    func present(error: URLError) {
        let viewModel = Home.Fetch.ViewModel(results: nil, error: error)
        viewController?.display(totalResults: 0, totalPages: 0, viewModel: viewModel)
    }
}
