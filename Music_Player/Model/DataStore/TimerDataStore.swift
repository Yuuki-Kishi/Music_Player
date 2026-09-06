//
//  TimerDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/03/30.
//

import Foundation

@MainActor
class TimerDataStore: ObservableObject {
    static let shared = TimerDataStore()
    @Published var sleepTimer: Timer? = nil
    @Published var remainTime: Int = 0
}
