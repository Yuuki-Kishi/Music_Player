//
//  TimerRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/08/24.
//

import Foundation

@MainActor
class TimerRepository {
    static let timerDataStore: TimerDataStore = .shared
    
    static func setTimer() {
        guard timerDataStore.remainTime > 0 else { return }
        timerDataStore.sleepTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    @objc static func countDown() {
        if timerDataStore.remainTime > 0 {
            timerDataStore.remainTime -= 1
        } else {
            timerDataStore.sleepTimer?.invalidate()
            PlayRepository.pause()
            timerDataStore.sleepTimer = nil
        }
    }
    
    
}
