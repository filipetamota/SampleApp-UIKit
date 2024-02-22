//
//  UIViewController.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 21/2/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentFavoriteAlert(result: Result<FavoriteOperation, SampleAppError>) {
        switch result {
        case .success(let favOp):
            presentAlert(title: NSLocalizedString("success", comment: ""), message: favOp.successAlertMessage())
        case .failure(let error):
            presentErrorAlert(error: error)
        }
    }
    
    func presentAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentErrorAlert(error: SampleAppError) {
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: error.errorMessage(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
