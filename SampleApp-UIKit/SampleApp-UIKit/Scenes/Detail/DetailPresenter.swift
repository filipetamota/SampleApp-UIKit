//
//  DetailPresenter.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//  Copyright (c) 2024. All rights reserved.
//

import UIKit

protocol DetailPresentationLogic
{
  func presentSomething(response: Detail.Something.Response)
}

class DetailPresenter: DetailPresentationLogic
{
  weak var viewController: DetailDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Detail.Something.Response)
  {
    let viewModel = Detail.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
