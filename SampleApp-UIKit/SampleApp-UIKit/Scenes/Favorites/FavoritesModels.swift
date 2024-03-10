//
//  FavoritesModels.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 21/2/24.
//

import UIKit

enum Favorites {
    enum Fetch {
        
        struct Response {
            let results: [FavoriteItem]
        }
        
        struct ViewModel {
            let results: [FavoriteItem]?
            let error: ModelError?
        }
    }
}
