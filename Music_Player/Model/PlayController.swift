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
    @Published var music = Music(musicName: "曲名", artistName: "アーティスト名", albumName: "アルバム名", editedDate: Date(), fileSize: "0MB", filePath: "path")
    @Published var seekPosition = 0.5
    @Published var isPlay = false
}
