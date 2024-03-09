//
//  FavoriteItem.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 21/2/24.
//

import Foundation

extension FavoriteItem {
    
    convenience init() {
        self.init()
    }
    
    func toSearchResult() -> SearchResult? {
        guard
            let id = favId
        else {
            assertionFailure("Id shouldn't be nil")
            return nil
        }
        
        return SearchResult(photoId: id, alt_description: alt_description, likes: Int(likes), thumbUrl: thumbUrl ?? "", userName: userName ?? NSLocalizedString("author_unknown", comment: ""))
            
    }
    
    func toDetailResult() -> DetailResult? {
        guard
            let id = favId
        else {
            assertionFailure("Id shouldn't be nil")
            return nil
        }
        
        return DetailResult(id: id, width: Int(width), height: Int(height), alt_description: alt_description, description: desc, likes: Int(likes), imgUrl: imageUrl ?? "", thumbUrl: thumbUrl ?? "", userName: userName ?? NSLocalizedString("author_unknown", comment: ""), equipment: equipment, location: location)
    }
}
