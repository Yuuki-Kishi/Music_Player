//
//  Music.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/17.
//

import Foundation

struct Music: Hashable, Identifiable {
    var id = UUID()
    var musicName: String
    var artistName: String
    var albumName: String
    var coverImage: Data
    var editedDate: Date
    var fileSize: String
    var musicLength: TimeInterval
    var filePath: String
    
    init(musicName: String, artistName: String, albumName: String, coverImage: Data, editedDate: Date, fileSize: String, musicLength: TimeInterval, filePath: String) {
        self.musicName = musicName
        self.artistName = artistName
        self.albumName = albumName
        self.coverImage = coverImage
        self.editedDate = editedDate
        self.fileSize = fileSize
        self.musicLength = musicLength
        self.filePath = filePath
    }
    
    init(musicName: String?, artistName: String?, albumName: String?, coverImage: Data?, editedDate: Date?, fileSize: String?, musicLength: TimeInterval?, filePath: String?) {
        self.musicName = musicName ?? "不明な曲"
        self.artistName = artistName ?? "不明なアーティスト"
        self.albumName = albumName ?? "不明なアルバム"
        self.coverImage = coverImage ?? Data()
        self.editedDate = editedDate ?? Date()
        self.fileSize = fileSize ?? "0MB"
        self.musicLength = musicLength ?? 0.0
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
        self.filePath = "unknownFilePath"
    }
}

@MainActor
extension Array where Element == Music {
    var selected: Element? {
        guard let selectedMusicFilePath = MusicDataStore.shared.selectedMusicFilePath else { return nil }
        return self.first { $0.filePath == selectedMusicFilePath }
    }
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(of: item) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
    mutating func remove(Music item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

@MainActor
extension Music {
    var isPlayingMusic: Bool {
        return self.filePath == PlayDataStore.shared.playingMusic?.filePath
    }
}

extension TimeInterval {
    var formattedTime: String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        if hours > 0 { return String(format: "%02d:%02d:%02d", hours, minutes, seconds) }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
