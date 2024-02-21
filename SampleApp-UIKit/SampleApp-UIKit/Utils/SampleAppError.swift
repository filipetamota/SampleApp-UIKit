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
    
    func errorMessage() -> String {
        switch self {
        case .connectionError(_):
            return NSLocalizedString("error_connection", comment: "")
        case .apiError:
            return NSLocalizedString("error_api", comment: "")
        case .parsingError:
            return NSLocalizedString("error_parsing", comment: "")
        case .requestError:
            return NSLocalizedString("error_request", comment: "")
        case .addFavoriteError:
            return NSLocalizedString("error_add_favorite", comment: "")
        case .removeFavoriteError:
            return NSLocalizedString("error_removed_favorite", comment: "")
        case .modelError:
            return NSLocalizedString("error_model", comment: "")
        case .unknownError:
            return NSLocalizedString("error_unknown", comment: "")
        }
    }
}
