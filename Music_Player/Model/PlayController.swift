//
//  PlayService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/17.
//

import Foundation

@MainActor
class PlayController: ObservableObject {
    static let shared = PlayController()
    @Published var musicName = "曲名"
    @Published var artistName = "アーティスト名"
    @Published var albumName = "アルバム名"
    @Published var seekPosition = 0.5
    @Published var isPlay = false
}
