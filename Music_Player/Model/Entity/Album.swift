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
