//
//  NotificationRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/06.
//

import Foundation
import MediaPlayer

@MainActor
class NotificationRepository {
    
    func setNowPlayingInfo() {
        let center = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = center.nowPlayingInfo ?? [String : Any]()
        
        // タイトル
        nowPlayingInfo[MPMediaItemPropertyTitle] = PlayDataStore.shared.playingMusic?.musicName
        nowPlayingInfo[MPMediaItemPropertyArtist] = PlayDataStore.shared.playingMusic?.artistName
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = PlayDataStore.shared.playingMusic?.albumName
        // サムネ
//        nowPlayingInfo[MPMediaItemPropertyArtwork] = UIImage(systemName: "music.note")
        // 再生位置
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = String(PlayDataStore.shared.seekPosition)
        // 現在の再生時間
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = String(PlayDataStore.shared.playingMusic?.musicLength ?? 300)
        // 曲の速さ
        if PlayDataStore.shared.isPlaying {
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        } else {
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
        }
        
        // メタデータを設定する
        center.nowPlayingInfo = nowPlayingInfo
    }
    
    func initRemoteCommand() {
        // 再生ボタン
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.removeTarget(self)
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { event in
            if PlayDataStore.shared.playingMusic == nil {
                return .noActionableNowPlayingItem
            } else {
                PlayDataStore.shared.play()
                return .success
            }
        }
        // 一時停止ボタン
        commandCenter.pauseCommand.removeTarget(self)
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { event in
            if PlayDataStore.shared.playingMusic == nil {
                return .noActionableNowPlayingItem
            } else {
                PlayDataStore.shared.pause()
                return .success
            }
        }
        // 前の曲ボタン
        commandCenter.previousTrackCommand.removeTarget(self)
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { event in
            if PlayDataStore.shared.playingMusic == nil {
                return .noActionableNowPlayingItem
            } else {
                PlayDataStore.shared.movePreviousMusic()
                return .success
            }
        }
        // 次の曲ボタン
        commandCenter.nextTrackCommand.removeTarget(self)
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { event in
            if PlayDataStore.shared.playingMusic == nil {
                return .noActionableNowPlayingItem
            } else {
                PlayDataStore.shared.moveNextMusic()
                return .success
            }
        }
        // シークバーでの秒数変更
        commandCenter.changePlaybackPositionCommand.removeTarget(self)
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { event in
            guard let positionCommandEvent = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            PlayDataStore.shared.seekPosition = Double(positionCommandEvent.positionTime)
            PlayDataStore.shared.setSeek()
            return .success
        }
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onInterruption(_:)), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        NotificationCenter.default.addObserver(self, selector: #selector(onAudioSessionRouteChanged(_:)), name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    @objc func onInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        switch type {
        case .began:
            if PlayDataStore.shared.isPlaying {
                PlayDataStore.shared.pause()
            }
            break
        case .ended:
            if !PlayDataStore.shared.isPlaying {
                PlayDataStore.shared.play()
            }
            break
        @unknown default:
            break
        }
    }
    
    @objc func onAudioSessionRouteChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
            return
        }
        
        switch reason {
        case .newDeviceAvailable:
            break
        case .oldDeviceUnavailable:
            PlayDataStore.shared.pause()
        default:
            break
        }
    }
}
