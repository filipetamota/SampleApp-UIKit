//
//  DetailRouter.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

@objc protocol DetailRoutingLogic { }

protocol DetailDataPassing {
    var dataStore: DetailDataStore? { get }
}

final class DetailRouter: NSObject, DetailRoutingLogic, DetailDataPassing {
    weak var viewController: DetailViewController?
    var dataStore: DetailDataStore?
}
