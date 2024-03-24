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
    var index: Int
    
    init(musicId: UUID, music: Music, index: Int) {
        self.musicId = musicId
        self.music = music
        self.index = index
    }
    
    init(music: Music, index: Int) {
        self.musicId = UUID()
        self.music = music
        self.index = index
    }
}
