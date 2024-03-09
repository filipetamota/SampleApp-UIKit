//
//  DetailWorker.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit
import CoreData

protocol DetailWorker {
    func fetch(request: Detail.Fetch.Request, completion: @escaping (Result<Detail.Fetch.Response, URLError>) -> Void)
    var apiClient: APIClient! { get set }
}

final class AppDetailWorker: DetailWorker {
    var apiClient: APIClient!
    
    func fetch(request: Detail.Fetch.Request, completion: @escaping (Result<Detail.Fetch.Response, URLError>) -> Void) {
        
        guard let urlRequest = Utils.buildURLRequest(requestData: request.data, pathVariable: request.photoId) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        Task {
            do {
                let dataResponse = try await apiClient.send(request: urlRequest)
                let response = try JSONDecoder().decode(Detail.Fetch.Response.self, from: dataResponse)
                completion(.success(response))
            } catch {
                completion(.failure(URLError(.cannotDecodeContentData)))
            }
        }
    }
}
