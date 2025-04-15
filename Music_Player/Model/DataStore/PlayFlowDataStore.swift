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
    @Published var willPlayMusicArray: [Music] = []
    @Published var playedMusicArray: [Music] = []
    @Published var isLoading: Bool = true
}
