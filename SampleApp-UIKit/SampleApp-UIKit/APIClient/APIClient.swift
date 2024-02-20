//
//  APIClient.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 17/2/24.
//

import Foundation

enum RequestData {
    case search
    case get
    
    func path() -> String {
        switch self {
        case .search:
            return "search/photos"
        case .get:
            return "photos/"
        }
    }
    
    func method() -> String {
        switch self {
        case .search, .get:
            return "GET"
        }
    }
}

class APIClient {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    init() {}
    
    public func send(request: URLRequest) async throws -> Data {
        let result = try await session.data(for: request)
        try validate(data: result.0, response: result.1)
        return result.0
    }
    
    func validate(data: Data, response: URLResponse) throws {
        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            throw APIClientError.connectionError(data)
        }
        guard (200..<300).contains(code) else {
            throw APIClientError.apiError
        }
    }
}
