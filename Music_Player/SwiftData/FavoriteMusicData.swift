//
//  FavoriteMusicData.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/13.
//

import Foundation
import SwiftData

@Model
final class FavoriteMusicData: Identifiable {
    @Attribute(.unique) var musicId: UUID
    var musicName: String?
    var artistName: String?
    var albumName: String?
    var editedDate: Date?
    var fileSize: String?
    var musicLength: TimeInterval?
    var filePath: String?
    
    init(musicId: UUID, musicName: String?, artistName: String?, albumName: String?, editedDate: Date?, fileSize: String?, musicLength: TimeInterval?, filePath: String?) {
        self.musicId = musicId
        self.musicName = musicName
        self.artistName = artistName
        self.albumName = albumName
        self.editedDate = editedDate
        self.fileSize = fileSize
        self.musicLength = musicLength
        self.filePath = filePath
    }
    
    init(musicName: String?, artistName: String?, albumName: String?, editedDate: Date?, fileSize: String?, musicLength: TimeInterval?, filePath: String?) {
        self.musicId = UUID()
        self.musicName = musicName
        self.artistName = artistName
        self.albumName = albumName
        self.editedDate = editedDate
        self.fileSize = fileSize
        self.musicLength = musicLength
        self.filePath = filePath
    }
}
