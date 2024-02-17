//
//  HomePresenter.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//  Copyright (c) 2024. All rights reserved.
//

import UIKit

protocol HomePresentationLogic {
    func present(response: Home.Fetch.Response)
    func present(error: Error)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
  
    func present(response: Home.Fetch.Response) {
        let viewModel = Home.Fetch.ViewModel()
        viewController?.display(viewModel: viewModel)
    }
    
    func present(error: Error) {
        
    }
}
