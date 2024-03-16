//
//  Playlisty.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/15.
//

import Foundation

class Playlist {
    var playlistName: String
    var musicCount: Int
    var musics: [Music]
    
    init(playlistName: String, musicCount: Int, musics: [Music]) {
        self.playlistName = playlistName
        self.musicCount = musicCount
        self.musics = musics
    }
}
