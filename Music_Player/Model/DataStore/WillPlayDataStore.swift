//
//  WillPlayDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/06.
//

import Foundation

@MainActor
class WillPlayDataStore: ObservableObject {
    static let shared = WillPlayDataStore()
    @Published var willPlayMusicArray: [Music] = []
}
