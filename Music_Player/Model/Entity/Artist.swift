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
