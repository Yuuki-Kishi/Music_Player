//
//  SetNotification.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/05/19.
//

import Foundation
import AVFoundation

class SetNotification {
    private let pc: PlayController
    
    init(pc: PlayController) {
        self.pc = pc
    }
    
    static func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onInterruption(_:)), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        NotificationCenter.default.addObserver(self, selector: #selector(onAudioSessionRouteChanged(_:)), name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    @MainActor @objc func onInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                  return
              }
        switch type {
        case .began:
            if pc.isPlay {
                pc.pause()
            }
            break
        case .ended:
            if !pc.isPlay {
                pc.play()
            }
            break
        @unknown default:
            break
        }
    }
    
    @MainActor @objc func onAudioSessionRouteChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
                  return
              }
        
        switch reason {
        case .newDeviceAvailable:
            if !pc.isPlay {
                pc.play()
            }
        case .oldDeviceUnavailable:
            if pc.isPlay {
                pc.pause()
            }
        default:
            break
        }
    }
}
