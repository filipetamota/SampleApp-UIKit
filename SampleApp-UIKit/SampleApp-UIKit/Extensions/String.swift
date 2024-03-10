//
//  String.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 20/2/24.
//

import Foundation

extension String {
    var capitalizeSentence: String {
        return self.prefix(1).capitalized + self.dropFirst()
    }
}
