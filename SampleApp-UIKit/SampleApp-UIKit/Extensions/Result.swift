//
//  Result.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 21/2/24.
//

import Foundation

extension Result where Success == Void {
    public static func success() -> Self { .success(()) }
}
