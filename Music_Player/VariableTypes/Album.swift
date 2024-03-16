//
//  Album.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/15.
//

import Foundation

class Album: Identifiable {
    var id = UUID()
    var albumName: String
    var musicCount: Int
    
    init(albumName: String, musicCount: Int) {
        self.albumName = albumName
        self.musicCount = musicCount
    }
}
