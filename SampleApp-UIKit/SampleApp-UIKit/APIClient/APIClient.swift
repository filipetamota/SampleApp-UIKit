//
//  APIClient.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 17/2/24.
//

import Foundation

class APIClient {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    init() {}
    
    public func send(request: URLRequest) async throws -> Home.Fetch.Response {
        let result = try await session.data(for: request)
        try validate(data: result.0, response: result.1)
        return try decoder.decode(Home.Fetch.Response.self, from: result.0)
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
