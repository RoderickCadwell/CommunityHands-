//
//  Item.swift
//  Cummunity Hands
//
//  Created by JOURNi Student on 7/27/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date = Date()) {
        self.timestamp = timestamp
    }
}
