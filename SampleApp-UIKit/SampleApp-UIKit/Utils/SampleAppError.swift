//
//  SampleAppError.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 17/2/24.
//

import Foundation

enum SampleAppError: Error {
    case connectionError(Data)
    case apiError
    case parsingError
    case requestError
    case addFavoriteError
    case removeFavoriteError
    case modelError
    case unknownError
}
