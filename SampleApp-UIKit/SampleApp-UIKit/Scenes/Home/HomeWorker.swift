//
//  HomeWorker.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

final class HomeWorker {
    func fetch(request: Home.Fetch.Request, completion: @escaping (Result<Home.Fetch.Response, SampleAppError>) -> Void) {
        
        guard let urlRequest = Utils.buildURLRequest(requestData: request.data, queryParams: [URLQueryItem(name: "query", value: request.query), URLQueryItem(name: "page", value: String(request.page))]) else {
            completion(.failure(.requestError))
            return
        }
        let apiClient = APIClient()
        Task {
            do {
                let dataResponse = try await apiClient.send(request: urlRequest)
                let response = try JSONDecoder().decode(Home.Fetch.Response.self, from: dataResponse)
                completion(.success(response))
            } catch {
                completion(.failure(.apiError))
            }
        }
    }
}
