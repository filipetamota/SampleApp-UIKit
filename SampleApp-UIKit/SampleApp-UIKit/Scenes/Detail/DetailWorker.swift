//
//  DetailWorker.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//

import UIKit
import CoreData

final class DetailWorker {
    
    func fetch(request: Detail.Fetch.Request, completion: @escaping (Result<Detail.Fetch.Response, SampleAppError>) -> Void) {
        
        guard let urlRequest = Utils.buildURLRequest(requestData: request.data, pathVariable: request.photoId) else {
            completion(.failure(.requestError))
            return
        }
        let apiClient = APIClient()
        Task {
            do {
                let dataResponse = try await apiClient.send(request: urlRequest)
                let response = try JSONDecoder().decode(Detail.Fetch.Response.self, from: dataResponse)
                completion(.success(response))
            } catch {
                completion(.failure(.apiError))
            }
        }
    }
}
