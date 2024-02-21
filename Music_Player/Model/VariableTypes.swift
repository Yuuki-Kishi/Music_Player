//
//  Music.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/17.
//

import Foundation
import SwiftData

struct Music: Codable, Hashable {
    var musicName: String
    var artistName: String
    var albumName: String
    var editedDate: Date
    var fileSize: String
    var filePath: String
    
    init(musicName: String, artistName: String, albumName: String, editedDate: Date, fileSize: String, filePath: String) {
        self.musicName = musicName
        self.artistName = artistName
        self.albumName = albumName
        self.editedDate = editedDate
        self.fileSize = fileSize
        self.filePath = filePath
    }
}

class Artist {
    var artistName: String
    var musicCount: Int
    
    init(artistName: String, musicCount: Int) {
        self.artistName = artistName
        self.musicCount = musicCount
    }
}

class Album {
    var albumName: String
    var musicCount: Int
    
    init(albumName: String, musicCount: Int) {
        self.albumName = albumName
        self.musicCount = musicCount
    }
}

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

class Folder {
    var folderName: String
    var musicCount: Int
    var folderPath: String
    
    init(folderName: String, musicCount: Int, folderPath: String) {
        self.folderName = folderName
        self.musicCount = musicCount
        self.folderPath = folderPath
    }
}
