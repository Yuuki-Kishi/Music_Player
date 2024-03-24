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
    var music: Music
    
    init(musicId: UUID, music: Music) {
        self.musicId = musicId
        self.music = music
    }
    
    init (music: Music) {
        self.musicId = UUID()
        self.music = music
    }
}
