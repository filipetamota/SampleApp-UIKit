//
//  DetailInteractor.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

protocol DetailBusinessLogic
{
  func doSomething(request: Detail.Something.Request)
}

protocol DetailDataStore
{
  //var name: String { get set }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore
{
  var presenter: DetailPresentationLogic?
  var worker: DetailWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: Detail.Something.Request)
  {
    worker = DetailWorker()
    worker?.doSomeWork()
    
    let response = Detail.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
