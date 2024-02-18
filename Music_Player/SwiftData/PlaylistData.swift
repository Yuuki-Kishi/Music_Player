//
//  playData.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/10.
//

import Foundation
import SwiftData

@Model
final class PlaylistData {
    @Attribute(.unique) var playlistId: String
    var playlistName: String
    var musicCount: Int
    var musics: [Music]
        
    init(playlistName: String) {
        let uuid = UUID()
        self.playlistId = uuid.uuidString
        self.playlistName = playlistName
        self.musicCount = 0
        self.musics = []
    }
}
