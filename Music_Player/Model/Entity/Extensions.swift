//
//  Extensions.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/09.
//

import Foundation

extension Array where Element == Music {
    mutating func remove(item: Element) {
        if let index = firstIndex(where: { $0.filePath == item.filePath }) {
            self.remove(at: index)
        }
    }
}

extension Array where Element == String {
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(of: item) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
    
    func droppedFisrt(_: Int) -> [String] {
        return Array(self.dropFirst(2))
    }
}

extension URL {
    var planePath: String {
        self.path(percentEncoded: false)
    }
}
