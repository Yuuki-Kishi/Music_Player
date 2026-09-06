//
//  Album.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/15.
//

import Foundation

struct Album: Hashable, Identifiable, Equatable {
    static func == (lhs: Album, rhs: Album) -> Bool {
        return lhs.albumName == rhs.albumName
    }
    
    var id = UUID()
    var albumName: String
    var musicCount: Int
    
    init(albumName: String, musicCount: Int) {
        self.albumName = albumName
        self.musicCount = musicCount
    }
    
    init() {
        self.albumName = "unknownAlbum"
        self.musicCount = 0
    }
}

@MainActor
extension Array where Element == Album {
    var selected: Element? {
        guard let selectedAlbumName = AlbumDataStore.shared.selectedAlbumName else { return nil }
        return self.first { $0.albumName == selectedAlbumName }
    }
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(of: item) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
    mutating func remove(Album item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}
