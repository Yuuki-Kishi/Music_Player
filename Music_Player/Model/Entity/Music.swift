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
    var fileSize: UInt64
    var musicLength: TimeInterval
    var filePath: String
    
    init(musicName: String, artistName: String, albumName: String, coverImage: Data, editedDate: Date, fileSize: UInt64, musicLength: TimeInterval, filePath: String) {
        self.musicName = musicName
        self.artistName = artistName
        self.albumName = albumName
        self.coverImage = coverImage
        self.editedDate = editedDate
        self.fileSize = fileSize
        self.musicLength = musicLength
        self.filePath = filePath
    }
    
    init(musicName: String?, artistName: String?, albumName: String?, coverImage: Data?, editedDate: Date?, fileSize: UInt64?, musicLength: TimeInterval?, filePath: String?) {
        self.musicName = musicName ?? String(localized: "Music.unknownMusicName")
        self.artistName = artistName ?? String(localized: "Music.unknownArtistName")
        self.albumName = albumName ?? String(localized: "Music.unknownAlbumName")
        self.coverImage = coverImage ?? Data()
        self.editedDate = editedDate ?? Date()
        self.fileSize = fileSize ?? 0
        self.musicLength = musicLength ?? 0.0
        self.filePath = filePath ?? String(localized: "Music.unknownFilePath")
    }
    
    init() {
        self.musicName = String(localized: "Music.unknownMusicName")
        self.artistName = String(localized: "Music.unknownArtistName")
        self.albumName = String(localized: "Music.unknownAlbumName")
        self.coverImage = Data()
        self.editedDate = Date()
        self.fileSize = 0
        self.musicLength = 0.0
        self.filePath = String(localized: "Music.unknownFilePath")
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
    var artistAndAlbumName: String {
        self.artistName + " - " + self.albumName
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
