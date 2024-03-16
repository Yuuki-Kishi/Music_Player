//
//  Artist.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/15.
//

import Foundation

class Artist: Identifiable {
    var id = UUID()
    var artistName: String
    var musicCount: Int
    
    init(artistName: String, musicCount: Int) {
        self.artistName = artistName
        self.musicCount = musicCount
    }
}
