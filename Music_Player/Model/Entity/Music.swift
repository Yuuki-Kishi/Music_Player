//
//  Music.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/17.
//

import Foundation

struct Music: Hashable, Identifiable, Equatable {
    static func == (lhs: Music, rhs: Music) -> Bool {
        return lhs.filePath == rhs.filePath
    }
    
    var id = UUID()
    var musicName: String
    var artistName: String
    var albumName: String
    var editedDate: Date
    var fileSize: String
    var musicLength: TimeInterval
    var filePath: String
    
    init(musicName: String, artistName: String, albumName: String, editedDate: Date, fileSize: String, musicLength: TimeInterval, filePath: String) {
        self.musicName = musicName
        self.artistName = artistName
        self.albumName = albumName
        self.editedDate = editedDate
        self.fileSize = fileSize
        self.musicLength = musicLength
        self.filePath = filePath
    }
    
    init(musicName: String?, artistName: String?, albumName: String?, fileSize: String?, musicLength: TimeInterval?, filePath: String?) {
        self.musicName = musicName ?? "不明な曲"
        self.artistName = artistName ?? "不明なアーティスト"
        self.albumName = albumName ?? "不明なアルバム"
        self.editedDate = Date()
        self.fileSize = fileSize ?? "0MB"
        self.musicLength = musicLength ?? 0.0
        self.filePath = filePath ?? "unknownFilePath"
    }
    
    init() {
        self.musicName = "不明な曲"
        self.artistName = "不明なアーティスト"
        self.albumName = "不明なアルバム"
        self.editedDate = Date()
        self.fileSize = "0MB"
        self.musicLength = 0.0
        self.filePath = "unknownFilePath"
    }
}

extension Array where Element == Music {
    mutating func remove(item: Element) {
        if let index = firstIndex(where: { $0.filePath == item.filePath }) {
            self.remove(at: index)
        }
    }
}
