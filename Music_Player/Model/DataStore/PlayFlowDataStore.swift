//
//  PlayFlowDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/15.
//

import Foundation

@MainActor
class PlayFlowDataStore: ObservableObject {
    static let shared = PlayFlowDataStore()
    @Published var playNextMusicArray: [Music] = []
    @Published var playBackMusicArray: [Music] = []
    @Published var isLoading: Bool = true
}
