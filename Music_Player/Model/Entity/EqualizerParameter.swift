//
//  Eq.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/13.
//

import Foundation
import SwiftData

@Model
final class EqualizerParameter: Sendable {
    @Attribute(.unique) var id: UUID = UUID()
    var type: UInt32
    var bandWidth: Float
    var frequency: Float
    var gain: Float
    
    init(type: UInt32, bandWidth: Float, frequency: Float, gain: Float) {
        self.type = type
        self.bandWidth = bandWidth
        self.frequency = frequency
        self.gain = gain
    }
}

extension Array where Element == EqualizerParameter {
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(of: item) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
}
