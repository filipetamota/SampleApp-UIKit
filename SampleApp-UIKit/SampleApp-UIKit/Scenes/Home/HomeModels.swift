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
            let data: RequestData
        }
        
        struct Response: Decodable {
            let total: Int
            let total_pages: Int
            let results: [SearchResult]
        }
        
        struct ViewModel {
            let results: [SearchResult]?
            let error: Error?
        }
    }
}

struct SearchResult: Decodable {
    let id: String
    let alt_description: String?
    let likes: Int
    let urls: Urls
    let user: User

}

struct Urls: Decodable {
    let thumb: String
}

struct User: Decodable {
    let id: String
    let username: String
    let name: String
}

enum RequestData {
    case search
    case get
    
    func path() -> String {
        switch self {
        case .search:
            return "/search/photos"
        case .get:
            return "/photos/:id"
        }
    }
    
    func method() -> String {
        switch self {
        case .search, .get:
            return "GET"
        }
    }
}
