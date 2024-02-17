//
//  APIClientError.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 17/2/24.
//

import Foundation

enum APIClientError: Error {
    case connectionError(Data)
    case apiError
    case parsingError
    case requestError
}
