//
//  Playlisty.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/15.
//

import Foundation

struct Playlist: Hashable, Identifiable, Equatable, Sendable {
    static func == (lhs: Playlist, rhs: Playlist) -> Bool {
        return lhs.filePath == rhs.filePath
    }
    
    var id = UUID()
    var playlistName: String
    var musicCount: Int
    var filePath: String
    
    init(playlistName: String, musicCount: Int, filePath: String) {
        self.playlistName = playlistName
        self.musicCount = musicCount
        self.filePath = filePath
    }
    
    init(playlistName: String) {
        self.playlistName = playlistName
        self.musicCount = 0
        self.filePath = "Playlist/" + "\(playlistName).m3u8"
    }
    
    init() {
        self.playlistName = "unknownPlaylist"
        self.musicCount = 0
        self.filePath = "unknownFilePath"
    }
}

@MainActor
extension Array where Element == Playlist {
    var selected: Element? {
        guard let selectedPlaylistFilePath = PlaylistDataStore.shared.selectedPlaylistFilePath else { return nil }
        return self.first { $0.filePath == selectedPlaylistFilePath }
    }
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(of: item) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
    mutating func remove(Playlist item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}
