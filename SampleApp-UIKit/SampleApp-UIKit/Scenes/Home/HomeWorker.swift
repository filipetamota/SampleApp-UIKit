//
//  HomeWorker.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//  Copyright (c) 2024. All rights reserved.
//

import UIKit

class HomeWorker {
    func doSomeWork(request: Home.Fetch.Request, completion: @escaping (Result<Home.Fetch.Response, Error>) -> Void) {
        guard let urlRequest = buildURLRequest(request: request) else {
            completion(.failure(APIClientError.requestError))
            return
        }
        let apiClient = APIClient()
        Task {
            do {
                let response = try await apiClient.send(request: urlRequest)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func buildURLRequest(request: Home.Fetch.Request) -> URLRequest? {
        guard 
            let domain = Bundle.main.object(forInfoDictionaryKey: "Domain") as? String,
            let accessKey = Bundle.main.object(forInfoDictionaryKey: "AccessKey") as? String,
            let baseURL = URL(string: domain)
        else {
            assertionFailure()
            return nil
        }
        let url = baseURL.appendingPathComponent(request.path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        switch request.method {
            case "GET":
                components?.queryItems = [URLQueryItem(name: "query", value: request.query)]
            default:
                assertionFailure()
                return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = request.method
        urlRequest.addValue(accessKey, forHTTPHeaderField: "Authorization")

        return urlRequest
    }
}
