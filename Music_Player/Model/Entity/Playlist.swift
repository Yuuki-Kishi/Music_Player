//
//  Playlisty.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/15.
//

import Foundation
import SwiftData

@Model
final class Playlist: Hashable, Identifiable, Equatable, Sendable {
    static func == (lhs: Playlist, rhs: Playlist) -> Bool {
        return lhs.playlistName == rhs.playlistName
    }
    
    @Attribute(.unique) var playlistId: UUID
    var playlistName: String
    var musicCount: Int
    var updateDate: Date
    var filePath: String
    
    init(playlistId: UUID , playlistName: String, musicCount: Int, updateDate: Date, filePath: String) {
        self.playlistId = playlistId
        self.playlistName = playlistName
        self.musicCount = musicCount
        self.updateDate = updateDate
        self.filePath = filePath
    }
    
    init(playlistName: String) {
        self.playlistId = UUID()
        self.playlistName = playlistName
        self.musicCount = 0
        self.updateDate = Date()
        self.filePath = "playlist/" + playlistName + ".m3u8"
    }
    
    init() {
        self.playlistId = UUID()
        self.playlistName = "unknownPlaylist"
        self.musicCount = 0
        self.updateDate = Date()
        self.filePath = "unknownFilePath"
    }
}
