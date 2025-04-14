//
//  Music.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/17.
//

import Foundation

struct Music: Hashable, Identifiable, Equatable {
    static func == (lhs: Music, rhs: Music) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = UUID()
    var musicName: String
    var artistName: String
    var albumName: String
    var coverImage: Data
    var editedDate: Date
    var fileSize: String
    var musicLength: TimeInterval
    var folderPath: String
    var filePath: String
    
    init(musicName: String, artistName: String, albumName: String, coverImage: Data, editedDate: Date, fileSize: String, musicLength: TimeInterval, folderPath: String, filePath: String) {
        self.musicName = musicName
        self.artistName = artistName
        self.albumName = albumName
        self.coverImage = coverImage
        self.editedDate = editedDate
        self.fileSize = fileSize
        self.musicLength = musicLength
        self.folderPath = folderPath
        self.filePath = filePath
    }
    
    init(musicName: String?, artistName: String?, albumName: String?, coverImage: Data?, editedDate: Date?, fileSize: String?, musicLength: TimeInterval?, folderPath: String?, filePath: String?) {
        self.musicName = musicName ?? "不明な曲"
        self.artistName = artistName ?? "不明なアーティスト"
        self.albumName = albumName ?? "不明なアルバム"
        self.coverImage = coverImage ?? Data()
        self.editedDate = editedDate ?? Date()
        self.fileSize = fileSize ?? "0MB"
        self.musicLength = musicLength ?? 0.0
        self.folderPath = folderPath ?? "unknownFolderPath"
        self.filePath = filePath ?? "unknownFilePath"
    }
    
    init() {
        self.musicName = "不明な曲"
        self.artistName = "不明なアーティスト"
        self.albumName = "不明なアルバム"
        self.coverImage = Data()
        self.editedDate = Date()
        self.fileSize = "0MB"
        self.musicLength = 0.0
        self.folderPath = "unknownFolderPath"
        self.filePath = "unknownFilePath"
    }
}
