//
//  HomeModels.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

enum Home {
    enum Fetch {
        struct Request {
            let query: String
            let page: Int
            let data: RequestData
        }
        
        struct Response: Decodable {
            let total: Int
            let total_pages: Int
            let results: [ResponseResult]
        }
        
        struct ViewModel {
            let results: [SearchResult]?
            let error: URLError?
        }
    }
}

struct ResponseResult: Decodable {
    let photoId: String
    let alt_description: String?
    let likes: Int
    let urls: HomeUrls
    let user: HomeUser
    
    private enum CodingKeys: String, CodingKey {
        case photoId = "id"
        case alt_description, likes, urls, user
    }
}

struct SearchResult: Decodable {
    let photoId: String
    let alt_description: String?
    let likes: Int
    let thumbUrl: String
    let userName: String
}

struct HomeUrls: Decodable {
    let thumb: String
}

struct HomeUser: Decodable {
    let name: String
}
