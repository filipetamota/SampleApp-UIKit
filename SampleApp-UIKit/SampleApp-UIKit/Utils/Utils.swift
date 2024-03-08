//
//  Utils.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 20/2/24.
//

import Foundation
import UIKit

final class Utils {
    
    static let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "Images Cache"
        return cache
    } ()

    static func buildURLRequest(requestData: RequestData, queryParams: [String: String]? = nil, pathVariable: String? = nil) -> URLRequest? {
        guard
            let domain = Bundle.main.object(forInfoDictionaryKey: "Domain") as? String,
            let accessKey = Bundle.main.object(forInfoDictionaryKey: "AccessKey") as? String,
            let baseURL = URL(string: domain)
        else {
            assertionFailure()
            return nil
        }
        var url = baseURL.appendingPathComponent(requestData.path())
        
        if let pathVariable = pathVariable {
            url = url.appendingPathComponent(pathVariable)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if  let queryParams = queryParams {
            components?.queryItems = queryParams.compactMap({ item in
                URLQueryItem(name: item.key, value: item.value)
            })
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = requestData.method()
        urlRequest.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")

        return urlRequest
    }
}
