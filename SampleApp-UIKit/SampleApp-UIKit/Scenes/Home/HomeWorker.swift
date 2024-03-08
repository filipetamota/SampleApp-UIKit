//
//  HomeWorker.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit

class HomeWorker {
    var apiClient: APIClient!

    func fetch(request: Home.Fetch.Request, completion: @escaping (Result<Home.Fetch.Response, URLError>) -> Void) {
        
        guard let urlRequest = Utils.buildURLRequest(requestData: request.data, queryParams: ["query": request.query, "page": String(request.page)]) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        Task {
            do {
                let dataResponse = try await apiClient.send(request: urlRequest)
                let response = try JSONDecoder().decode(Home.Fetch.Response.self, from: dataResponse)
                completion(.success(response))
            } catch {
                completion(.failure(URLError(.cannotDecodeContentData)))
            }
        }
    }
}
