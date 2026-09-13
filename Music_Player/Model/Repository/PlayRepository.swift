//
//  PlayRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/07/28.
//

import Foundation
import AVFoundation

@MainActor
class PlayRepository {
    static let playDataStore: PlayDataStore = .shared
    
    static func setMusic(music: Music) {
        playDataStore.playingMusic = music
        UserDefaultsRepository.save(key: "PlayingMusicFilePath", value: music.filePath)
    }
    
    static func setScheduleFile() {
        //currentItem.itemはMPMediaItemクラス
        guard let filePath = playDataStore.playingMusic?.filePath else { return }
        guard let fileURL = FileService.documentDirectory?.appendingPathComponent(filePath) else { return }
        do {
            // Source fileを取得する
            let audioFile = try AVAudioFile(forReading: fileURL)
            // PlayerNodeからAudioEngineのoutput先であるmainMixerNodeへ接続する
            playDataStore.audioEngine.connect(playDataStore.playerNode, to: playDataStore.equalizerNode, format: nil)
            playDataStore.audioEngine.connect(playDataStore.equalizerNode, to: playDataStore.audioEngine.mainMixerNode, format: nil)
            // 再生準備
            playDataStore.playerNode.scheduleFile(audioFile, at: nil, completionCallbackType: .dataRendered)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func setTimer() {
        playDataStore.seekPositionUpdateTimer?.invalidate()
        playDataStore.seekPositionUpdateTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateSeekPosition), userInfo: nil, repeats: true)
    }
    
    @objc static func updateSeekPosition() {
        // 最後にサンプリングしたデータを取得する ①
        guard let nodeTime = playDataStore.playerNode.lastRenderTime else { return }
        // playerNodeの時間軸に変換する ②
        guard let playerTime = playDataStore.playerNode.playerTime(forNodeTime: nodeTime) else { return }
        // サンプルレートとサンプルタイム取得する ③
        let sampleRate = playerTime.sampleRate
        let sampleTime = playerTime.sampleTime
        // 秒数を取得し保持する ④
        let musicLength = playDataStore.playingMusic?.musicLength ?? 300
        let currentTime = min(max(0, Double(sampleTime) / sampleRate + playDataStore.cashedSeekBarSeconds), musicLength)
        isEndOfFile(currentTime: currentTime)
        playDataStore.seekPosition = currentTime
        NotificationRepository.setNowPlayingInfo()
    }
    
    static func isEndOfFile(currentTime: Double) {
        //ファイルの長さ
        let fileDuration = Double(playDataStore.playingMusic?.musicLength ?? 300)
        if currentTime >= fileDuration {
            moveNextMusic()
        }
    }
    
    static func setSeek() {
        guard let filePath = playDataStore.playingMusic?.filePath else { return }
        guard let fileURL = FileService.documentDirectory?.appendingPathComponent(filePath) else { return }
        guard let audioFile = try? AVAudioFile(forReading: fileURL) else { return }
        // サンプルレートを取得する
        let sampleRate = audioFile.processingFormat.sampleRate
        // 変更する秒数のSampleTimeを取得する
        let startSampleTime = AVAudioFramePosition(sampleRate * playDataStore.seekPosition)
        // 変更した後の曲の残り時間とそのSampleTimeを取得する(曲の秒数-変更する秒数)
        let remainSampleTime = AVAudioFrameCount(audioFile.length - startSampleTime)
        // 変更した秒数をキャッシュしておく
        playDataStore.cashedSeekBarSeconds = Double(playDataStore.seekPosition)
        // 変更した秒数から曲を再生し直すため、AudioEngineとPlayerNodeを停止する
        stop()
        // 曲の再生秒数の変更メソッド
        playDataStore.playerNode.scheduleSegment(audioFile, startingFrame: startSampleTime, frameCount: remainSampleTime, at: nil)
        NotificationRepository.setNowPlayingInfo()
        // 停止状態なので再生する
        play()
    }
    
    static func play() {
        // 再生処理
        do {
            try playDataStore.audioSession.setActive(true, options: [])
            try playDataStore.audioEngine.start()
            playDataStore.playerNode.play()
            NotificationRepository.setNowPlayingInfo()
            playDataStore.isPlaying = true
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func pause() {
        playDataStore.isPlaying = false
        playDataStore.audioEngine.pause()
        playDataStore.playerNode.pause()
        NotificationRepository.setNowPlayingInfo()
    }
    
    static func stop() {
        playDataStore.isPlaying = false
        playDataStore.audioEngine.stop()
        playDataStore.playerNode.stop()
    }
    
    static func randomPlay(musics: [Music]) {
        guard let music = musics.randomElement() else { return }
        musicSelected(music: music)
        setPlayNextMusics(musics: musics)
    }
    
    static func musicSelected(music: Music) {
        playDataStore.seekPosition = 0.0
        playDataStore.cashedSeekBarSeconds = 0.0
        guard FileService.isExist(path: music.filePath) else { return }
        setMusic(music: music)
        setScheduleFile()
        setTimer()
        play()
    }
    
    static func setPlayNextMusics(musics: [Music]) {
        var musics = musics
        guard let playingMusic = playDataStore.playingMusic else { return }
        musics.remove(Music: playingMusic)
        if playDataStore.isShuffle {
            musics.shuffle()
        } else {
            musics.sort { $0.musicName < $1.musicName }
        }
        guard PlayFlowRepository.cleanUpPlayNextM3U8() else { return }
        guard PlayFlowRepository.cleanUpPlayBackM3U8() else { return }
        guard PlayFlowRepository.writePlayNextM3U8(filePaths: musics.map { $0.filePath }) else { return }
        print("setSucceeded")
    }
    
    static func moveNextMusic() {
        Task {
            stop()
            playDataStore.seekPosition = 0.0
            playDataStore.cashedSeekBarSeconds = 0.0
            switch playDataStore.repeatMode {
            case .all:
                guard let playingMusicFilePath = playDataStore.playingMusic?.filePath else { return }
                guard PlayFlowRepository.addPlayBackM3U8(filePath: playingMusicFilePath) else { return }
                if PlayFlowRepository.getPlayNextM3U8FilePaths().isEmpty {
                    var playBackMusics = await PlayFlowRepository.getPlayBackM3U8()
                    if playDataStore.isShuffle {
                        playBackMusics.shuffle()
                    } else {
                        playBackMusics.sort { $0.musicName < $1.musicName }
                    }
                    guard PlayFlowRepository.writePlayNextM3U8(filePaths: playBackMusics.map { $0.filePath }) else { return }
                    guard PlayFlowRepository.cleanUpPlayBackM3U8() else { return }
                }
                guard let nextMusicFilePath = PlayFlowRepository.getNextMusicFilePath() else { return }
                guard let nextMusic = await FileService.getFileMetadata(filePath: nextMusicFilePath) else { return }
                guard PlayFlowRepository.removePlayNextFirstMusic() else { return }
                setMusic(music: nextMusic)
            case .one:
                guard let playingMusic = playDataStore.playingMusic else { return }
                setMusic(music: playingMusic)
            case .off:
                guard let playingMusicFilePath = playDataStore.playingMusic?.filePath else { return }
                guard PlayFlowRepository.addPlayBackM3U8(filePath: playingMusicFilePath) else { return }
                guard !PlayFlowRepository.getPlayNextM3U8FilePaths().isEmpty else {
                    playDataStore.playingMusic = nil
                    NotificationRepository.setNowPlayingInfo()
                    return
                }
                guard let nextMusicFilePath = PlayFlowRepository.getNextMusicFilePath() else { return }
                guard let nextMusic = await FileService.getFileMetadata(filePath: nextMusicFilePath) else { return }
                guard PlayFlowRepository.removePlayNextFirstMusic() else { return }
                setMusic(music: nextMusic)
            }
            setScheduleFile()
            setTimer()
            play()
        }
    }
    
    static func movePreviousMusic() {
        Task {
            stop()
            playDataStore.seekPosition = 0.0
            playDataStore.cashedSeekBarSeconds = 0.0
            guard let playingMusicFilePath = playDataStore.playingMusic?.filePath else { return }
            guard PlayFlowRepository.insertFirstPlayNextM3U8(filePath: playingMusicFilePath) else { return }
            guard !PlayFlowRepository.getPlayBackM3U8FilePaths().isEmpty else {
                playDataStore.playingMusic = nil
                NotificationRepository.setNowPlayingInfo()
                return
            }
            guard let previousMusicFilePath = PlayFlowRepository.getPreviousMusicFilePath() else { return }
            guard let previousMusic = await FileService.getFileMetadata(filePath: previousMusicFilePath) else { return }
            guard PlayFlowRepository.removePlayBackLastMusic() else { return }
            setMusic(music: previousMusic)
            setScheduleFile()
            setTimer()
            play()
        }
    }
    
    static func loadPlayingMusic() async -> Music? {
        guard let playingMusicFilePath = UserDefaultsRepository.load(key: "PlayingMusicFilePath", as: String.self) else  { return nil }
        guard FileService.isExist(path: playingMusicFilePath) else { return nil }
        guard let playingMusic = await FileService.getFileMetadata(filePath: playingMusicFilePath) else { return nil }
        return playingMusic
    }
    
    static func toggleIsShuffle() {
        playDataStore.isShuffle.toggle()
        guard PlayFlowRepository.rearrangePlayNextM3U8() else { return }
        UserDefaultsRepository.save(key: "isShuffle", value: playDataStore.isShuffle)
    }
    
    static func changeRepeatMode() {
        switch playDataStore.repeatMode {
        case .all:
            playDataStore.repeatMode = .one
        case .one:
            playDataStore.repeatMode = .off
        case .off:
            playDataStore.repeatMode = .all
        }
        UserDefaultsRepository.save(key: "repeatMode", value: playDataStore.repeatMode.rawValue)
    }
}
