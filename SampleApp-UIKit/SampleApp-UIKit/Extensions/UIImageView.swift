//
//  UIImageView.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 20/2/24.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFromUrl(urlString: String) {
        if let image = Utils.cache.object(forKey: NSString(string: urlString)) {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask( with: url, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let data = data {
                    if let image = UIImage(data: data) {
                        self.image = image
                        Utils.cache.setObject(image, forKey: NSString(string: urlString))
                    }
                }
            }
        }).resume()
    }
}
