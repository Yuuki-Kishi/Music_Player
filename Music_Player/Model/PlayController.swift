//
//  PlayService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/17.
//

import Foundation

final class PlayController {
    static let shared = PlayController()
    var musicName = "曲名"
    var artistName = "アーティスト名"
    var albumName = "アルバム名"
    var seekPosition = 0.5
    var isPlay = false
}
