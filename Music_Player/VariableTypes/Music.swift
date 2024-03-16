//
//  Music.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/17.
//

import Foundation

struct Music: Codable, Hashable, Identifiable {
    var id = UUID()
    var musicName: String?
    var artistName: String?
    var albumName: String?
    var editedDate: Date?
    var fileSize: String?
    var musicLength: TimeInterval?
    var filePath: String?
    
    init(musicName: String?, artistName: String?, albumName: String?, editedDate: Date?, fileSize: String?, musicLength: TimeInterval?, filePath: String?) {
        self.musicName = musicName
        self.artistName = artistName
        self.albumName = albumName
        self.editedDate = editedDate
        self.fileSize = fileSize
        self.musicLength = musicLength
        self.filePath = filePath
    }
    
    init() {
        self.musicName = "曲名"
        self.artistName = "アーティスト名"
        self.albumName = "アルバム名"
        self.editedDate = Date()
        self.fileSize = "0MB"
        self.filePath = "path"
    }
}
