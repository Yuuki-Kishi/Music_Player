//
//  PlayedDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/06.
//

import Foundation

@MainActor
class PlayedDataStore: ObservableObject {
    static let shared = PlayedDataStore()
    @Published var playedMusicArray: [Music] = []
}
