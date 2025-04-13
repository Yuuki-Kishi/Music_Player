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
    static let playDataStore = PlayDataStore.shared
    
    static func setNowPlayingInfo() {
        let center = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = center.nowPlayingInfo ?? [String : Any]()
        
        // タイトル
        nowPlayingInfo[MPMediaItemPropertyTitle] = playDataStore.playingMusic?.musicName
        nowPlayingInfo[MPMediaItemPropertyArtist] = playDataStore.playingMusic?.artistName
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = playDataStore.playingMusic?.albumName
        // サムネ
        //        nowPlayingInfo[MPMediaItemPropertyArtwork] = UIImage(systemName: "music.note")
        // 再生位置
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = String(playDataStore.seekPosition)
        // 現在の再生時間
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = String(playDataStore.playingMusic?.musicLength ?? 300)
        // 曲の速さ
        if playDataStore.isPlaying {
//            guard let filePath = playDataStore.playingMusic?.filePath else { return }
//            let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
//            let fullFilePath = directoryPath + "/" + filePath
//            let assetURL = URL(fileURLWithPath: fullFilePath)
//            guard let audioFile = try? AVAudioFile(forReading: assetURL) else { return }
//            let sampleRate = audioFile.processingFormat.sampleRate
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        } else {
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
        }
        
        // メタデータを設定する
        center.nowPlayingInfo = nowPlayingInfo
    }
    
    static func initRemoteCommand() {
        // 再生ボタン
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.removeTarget(self)
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { event in
            NotificationRepository.playDataStore.play()
            return .success
        }
        // 一時停止ボタン
        commandCenter.pauseCommand.removeTarget(self)
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { event in
            NotificationRepository.playDataStore.pause()
            return .success
        }
        // 前の曲ボタン
        commandCenter.previousTrackCommand.removeTarget(self)
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { event in
//            moveBeforeMusic()
            return .success
        }
        // 次の曲ボタン
        commandCenter.nextTrackCommand.removeTarget(self)
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { event in
//            moveNextMusic()
            return .success
        }
        // シークバーでの秒数変更
        commandCenter.changePlaybackPositionCommand.removeTarget(self)
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { event in
            guard let positionCommandEvent = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            NotificationRepository.playDataStore.seekPosition = Double(positionCommandEvent.positionTime)
            NotificationRepository.playDataStore.setSeek()
            return .success
        }
    }
    
    static func setNotification() {
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
            if NotificationRepository.playDataStore.isPlaying {
                NotificationRepository.playDataStore.pause()
            }
            break
        case .ended:
            if !NotificationRepository.playDataStore.isPlaying {
                NotificationRepository.playDataStore.play()
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
            if !NotificationRepository.playDataStore.isPlaying {
                NotificationRepository.playDataStore.play()
            }
        case .oldDeviceUnavailable:
            if NotificationRepository.playDataStore.isPlaying {
                NotificationRepository.playDataStore.pause()
            }
        default:
            break
        }
    }
}
