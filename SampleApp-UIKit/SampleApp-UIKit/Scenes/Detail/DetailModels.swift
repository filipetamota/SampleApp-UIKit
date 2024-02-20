//
//  DetailModels.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

enum Detail {
    enum Fetch
    {
        struct Request {
            let photoId: String
            let data: RequestData
        }
        
        struct Response: Decodable {
            let id: String
            let alt_description: String?
            let description: String?
            let likes: Int
            let urls: DetailUrls
            let user: DetailUser
            let exif: Equipment?
            let location: Location?
        }
        
        struct ViewModel {
            let result: DetailResult?
            let error: Error?
        }
    }
}

struct DetailResult: Decodable {
    let id: String
    let alt_description: String?
    let description: String?
    let likes: Int
    let imgUrl: String
    let userName: String?
    let equipment: String?
    let location: String?
}

struct DetailUrls: Decodable {
    let regular: String
}

struct DetailUser: Decodable {
    let id: String
    let username: String
    let name: String
}

struct Equipment: Decodable {
    let name: String?
}

struct Location: Decodable {
    let name: String?
}
