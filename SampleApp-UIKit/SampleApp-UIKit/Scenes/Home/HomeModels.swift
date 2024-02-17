//
//  HomeModels.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 15/2/24.
//  Copyright (c) 2024. All rights reserved.
//

import UIKit

enum Home {
    enum Fetch {
        struct Request {
            let query: String
            let path: String
            let method: String
        }
        
        struct Response: Decodable {
            
        }
        
        struct ViewModel {
            
        }
    }
}
