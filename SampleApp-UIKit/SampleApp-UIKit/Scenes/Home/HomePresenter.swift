//
//  HomePresenter.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//  Copyright (c) 2024. All rights reserved.
//

import UIKit

protocol HomePresentationLogic
{
  func presentSomething(response: Home.Something.Response)
}

class HomePresenter: HomePresentationLogic
{
  weak var viewController: HomeDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Home.Something.Response)
  {
    let viewModel = Home.Something.ViewModel()
  //  viewController?.displaySomething(viewModel: viewModel)
  }
}
