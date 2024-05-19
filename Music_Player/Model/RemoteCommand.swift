//
//  RemoteCommand.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/05/19.
//

import Foundation
import MediaPlayer

class RemoteCommand {
    private let pc: PlayController
    
    init(pc: PlayController) {
        self.pc = pc
    }
    
    static func initRemoteCommand() {
        // 再生ボタン
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.removeTarget(self)
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [unowned self] event in
            pc.play()
            return .success
        }
        // 一時停止ボタン
        commandCenter.pauseCommand.removeTarget(self)
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            pc.pause()
            return .success
        }
        // 前の曲ボタン
        commandCenter.previousTrackCommand.removeTarget(self)
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            pc.moveBeforeMusic()
            return .success
        }
        // 次の曲ボタン
        commandCenter.nextTrackCommand.removeTarget(self)
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            pc.moveNextMusic()
            return .success
        }
        // シークバーでの秒数変更
        commandCenter.changePlaybackPositionCommand.removeTarget(self)
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
            guard let positionCommandEvent = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            pc.seekPosition = Double(positionCommandEvent.positionTime)
            pc.setSeek()
            return .success
        }
    }
}
