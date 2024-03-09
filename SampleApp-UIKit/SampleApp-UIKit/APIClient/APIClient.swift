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

protocol APIClient {
    func send(request: URLRequest) async throws -> Data
}

final class AppAPIClient: APIClient {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    init() {}
    
    func send(request: URLRequest) async throws -> Data {
        let result = try await session.data(for: request)
        try validate(data: result.0, response: result.1)
        return result.0
    }
    
    private func validate(data: Data, response: URLResponse) throws {
        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            throw URLError(.badServerResponse)
        }
        guard (200..<300).contains(code) else {
            throw URLError(.badServerResponse)
        }
    }
}
