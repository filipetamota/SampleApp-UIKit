//
//  FavoriteItem.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 21/2/24.
//

import Foundation

extension FavoriteItem {
    func toSearchResult() -> SearchResult? {
        guard
            let id = favId,
            let thumbUrl = thumbUrl,
            let userName = userName
        else {
            return nil
        }
        
        return SearchResult(id: id, alt_description: alt_description, likes: Int(likes), thumbUrl: thumbUrl, userName: userName)
            
    }
    
    func toDetailResult() -> DetailResult? {
        guard
            let id = favId,
            let thumbUrl = thumbUrl,
            let imgUrl = imageUrl,
            let userName = userName
        else {
            return nil
        }
        
        return DetailResult(id: id, width: Int(width), height: Int(height), alt_description: alt_description, description: desc, likes: Int(likes), imgUrl: imgUrl, thumbUrl: thumbUrl, userName: userName, equipment: equipment, location: location)
    }
}
