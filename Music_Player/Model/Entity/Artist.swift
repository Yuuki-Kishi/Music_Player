//
//  Artist.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/15.
//

import Foundation

struct Artist: Hashable, Identifiable, Equatable {
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.artistName == rhs.artistName
    }
    
    var id = UUID()
    var artistName: String
    var musicCount: Int
    
    init(artistName: String, musicCount: Int) {
        self.artistName = artistName
        self.musicCount = musicCount
    }
    
    init() {
        self.artistName = "unknownArtist"
        self.musicCount = 0
    }
}

@MainActor
extension Array where Element == Artist {
    var selected: Element? {
        guard let selectedArtistName = ArtistDataStore.shared.selectedArtistName else { return nil }
        return self.first { $0.artistName == selectedArtistName }
    }
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(of: item) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
    mutating func remove(Artist item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}
