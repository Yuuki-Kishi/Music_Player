//
//  DidPlayMusicData.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import Foundation
import SwiftData

@Model
final class DidPlayMusicData: Identifiable {
    @Attribute(.unique) var musicId: UUID
    var music: Music
    var addedTime: Date
    
    init(musicId: UUID, music: Music, addedTime: Date) {
        self.musicId = musicId
        self.music = music
        self.addedTime = addedTime
    }
    
    init(music: Music) {
        self.musicId = UUID()
        self.music = music
        self.addedTime = Date()
    }
}
