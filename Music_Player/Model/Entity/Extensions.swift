//
//  Extensions.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/09.
//

import Foundation

extension Array where Element == String {
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(of: item) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
    mutating func remove(item: Element) {
        if let index = firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

extension URL {
    var planePath: String {
        self.path(percentEncoded: false)
    }
    var isMusicFile: Bool {
        let musicExtensions: Set<String> = ["mp3", "m4a", "aac", "flac", "wav", "ogg"]
        return musicExtensions.contains(pathExtension.lowercased())
    }
}

extension Int {
    var timeFormatted: String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 60
        if hours > 0 { return String(format: "%02d:%02d:%02d", hours, minutes, seconds) }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
