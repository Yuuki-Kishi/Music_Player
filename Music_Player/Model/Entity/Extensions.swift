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
    
    func droppedFisrt(index: Int) -> [Element] {
        return Array(self.dropFirst(index))
    }
}

extension Array where Element == Music {
    func droppedFisrt(index: Int) -> [Element] {
        return Array(self.dropFirst(index))
    }
}

extension URL {
    var planePath: String {
        self.path(percentEncoded: false)
    }
    var isMusicFile: Bool {
        let isTrashed = self.planePath.contains("/.Trash")
        let isPlaylist = self.planePath.contains("/playlist")
        let isSystem = self.planePath.contains("/System")
        let isM3U8 = self.planePath.contains(".m3u8")
        let isDSStore = self.planePath.contains(".DS_Store")
        return !isTrashed && !isPlaylist && !isSystem && !isM3U8 && !isDSStore
    }
}
