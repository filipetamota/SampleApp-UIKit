//
//  HomeWorker.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

final class HomeWorker {
    func fetch(request: Home.Fetch.Request, completion: @escaping (Result<Home.Fetch.Response, Error>) -> Void) {
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
    
    private func buildURLRequest(request: Home.Fetch.Request) -> URLRequest? {
        guard
            let domain = Bundle.main.object(forInfoDictionaryKey: "Domain") as? String,
            let accessKey = Bundle.main.object(forInfoDictionaryKey: "AccessKey") as? String,
            let baseURL = URL(string: domain)
        else {
            assertionFailure()
            return nil
        }
        let url = baseURL.appendingPathComponent(request.data.path())
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        switch request.data.method() {
            case "GET":
                components?.queryItems = [URLQueryItem(name: "query", value: request.query)]
            default:
                assertionFailure()
                return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = request.data.method()
        urlRequest.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")

        return urlRequest
    }
}
