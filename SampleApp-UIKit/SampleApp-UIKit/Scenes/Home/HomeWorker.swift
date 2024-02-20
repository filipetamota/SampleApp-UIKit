//
//  HomeWorker.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

final class HomeWorker {
    func fetch(request: Home.Fetch.Request, completion: @escaping (Result<Home.Fetch.Response, Error>) -> Void) {
        
        guard let urlRequest = Utils.buildURLRequest(requestData: request.data, queryParams: [URLQueryItem(name: "query", value: request.query)]) else {
            completion(.failure(APIClientError.requestError))
            return
        }
        let apiClient = APIClient()
        Task {
            do {
                let dataResponse = try await apiClient.send(request: urlRequest)
                let response = try JSONDecoder().decode(Home.Fetch.Response.self, from: dataResponse)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
