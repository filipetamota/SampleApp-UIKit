//
//  DetailPresenter.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

protocol DetailPresentationLogic {
    func present(response: Detail.Fetch.Response)
    func present(savedFavorite: FavoriteItem)
    func present(error: Error)
}

final class DetailPresenter: DetailPresentationLogic {
    weak var viewController: DetailDisplayLogic?
    typealias ViewModel = Detail.Fetch.ViewModel
  
    func present(response: Detail.Fetch.Response) {
        let viewModel = ViewModel(result: DetailResult(id: response.id,
                                                                    width: response.width,
                                                                    height: response.height,
                                                                    alt_description: response.alt_description,
                                                                    description: response.description,
                                                                    likes: response.likes,
                                                                    imgUrl: response.urls.regular, 
                                                                    thumbUrl: response.urls.thumb,
                                                                    userName: response.user.name,
                                                                    equipment: response.exif?.model,
                                                                    location: response.location?.name),
                                               error: nil)
        viewController?.display(viewModel: viewModel)
    }
    
    func present(savedFavorite: FavoriteItem) {
        let viewModel = ViewModel(result: savedFavorite.toDetailResult, error: nil)
        viewController?.display(viewModel: viewModel)
    }
    
    func present(error: Error) {
        let viewModel = Detail.Fetch.ViewModel(result: nil, error: error)
        viewController?.display(viewModel: viewModel)
    }
}
