//
//  ViewDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/03/30.
//

import Foundation

@MainActor
class ViewDataStore: ObservableObject {
    static let shared = ViewDataStore()
    @Published var isShowPlayView: Bool = false
    @Published var sleepTimer: Timer? = nil
    @Published var remainTime: Int = 0
    
    func setTimer(setTime: Int) {
        if setTime > 0 {
            remainTime = setTime
            sleepTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        }
    }
    @objc func countDown() {
        if remainTime > 0 {
            remainTime -= 1
        } else {
            sleepTimer?.invalidate()
            PlayDataStore.shared.pause()
            sleepTimer = nil
        }
    }
}

extension Int {
    var toTime: String {
        let hour = self / 3600
        let min = (self - hour * 3600) / 60
        let sec = (self - hour * 3600) % 60
        let hourString = hour < 10 ? "0" + String(hour) : String(hour)
        let minString = min < 10 ? "0" + String(min) : String(min)
        let secString = sec < 10 ? "0" + String(sec) : String(sec)
        return hourString + ":" + minString + ":" + secString
    }
}
