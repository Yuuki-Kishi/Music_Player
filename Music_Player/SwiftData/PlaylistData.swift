//
//  playData.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/10.
//

import Foundation
import SwiftData

@Model
final class PlaylistData: Identifiable {
    @Attribute(.unique) var playlistId: UUID
    var playlistName: String
    var musicCount: Int
    var musics: [Music]
        
    init(playlistName: String) {
        self.playlistId = UUID()
        self.playlistName = playlistName
        self.musicCount = 0
        self.musics = []
    }
    
    init(playlistName: String, musicCount: Int, musics: [Music]) {
        self.playlistId = UUID()
        self.playlistName = playlistName
        self.musicCount = musicCount
        self.musics = musics
    }
    
    init(playlistId: UUID, playlistName: String, musicCount: Int, musics: [Music]) {
        self.playlistId = playlistId
        self.playlistName = playlistName
        self.musicCount = musicCount
        self.musics = musics
    }
}
