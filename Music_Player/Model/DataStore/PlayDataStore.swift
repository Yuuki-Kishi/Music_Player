//
//  PlayDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import Foundation
import AVFoundation

@MainActor
class PlayDataStore: ObservableObject {
    static let shared = PlayDataStore()
    @Published var playingMusic: Music? = nil
    @Published var seekPosition: Double = 0.0
    private var seekPositionUpdateTimer: Timer?
    @Published var cashedSeekBarSeconds: Double = 0.0
    @Published var isPlaying: Bool = false
    @Published var playMode: PlayMode = .shuffle
    @Published var playGroup: PlayGroup = .music
    private let audioEngine: AVAudioEngine = .init()
    private let playerNode: AVAudioPlayerNode = .init()
    
    enum PlayMode: String {
        case shuffle, order, sameRepeat
    }
    
    enum PlayGroup: String {
        case music, artist, album, playlist, folder, favorite
    }
    
    init() {
        // 接続するオーディオノードをAudioEngineにアタッチする
        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)
        NotificationRepository.initRemoteCommand()
        NotificationRepository.setNotification()
        stop()
    }
    
    func setMusic(music: Music) {
        self.playingMusic = music
//        savePlayingMusic(music: music)
    }
    
    func setScheduleFile() {
        //currentItem.itemはMPMediaItemクラス
        guard let filePath = playingMusic?.filePath else { return }
        guard let fileURL = FileService.documentDirectory?.appendingPathComponent(filePath) else { return }
        do {
            // Source fileを取得する
            let audioFile = try AVAudioFile(forReading: fileURL)
            // PlayerNodeからAudioEngineのoutput先であるmainMixerNodeへ接続する
            audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)
            // 再生準備
            playerNode.scheduleFile(audioFile, at: nil, completionCallbackType: .dataRendered)
        }
        catch let error {
            print(error.localizedDescription)
            return
        }
    }
    
    func setTimer() {
        seekPositionUpdateTimer?.invalidate()
        seekPositionUpdateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSeekPosition), userInfo: nil, repeats: true)
    }
    
    @objc func updateSeekPosition() {
        // 最後にサンプリングしたデータを取得する ①
        guard let nodeTime = playerNode.lastRenderTime else { return }
        // playerNodeの時間軸に変換する ②
        guard let playerTime = playerNode.playerTime(forNodeTime: nodeTime) else { return }
        // サンプルレートとサンプルタイム取得する ③
        let sampleRate = playerTime.sampleRate
        let sampleTime = playerTime.sampleTime
        // 秒数を取得し保持する ④
        let currentTime = Double(sampleTime) / sampleRate + cashedSeekBarSeconds
        isEndOfFile(currentTime: currentTime)
        seekPosition = currentTime
    }
    
    func isEndOfFile(currentTime: Double) {
        //ファイルの長さ
        let fileDuration = Double(playingMusic?.musicLength ?? 300)
        
        if currentTime >= fileDuration {
            moveNextMusic()
        }
    }
    
    func moveNextMusic() {
        stop()
        seekPosition = 0.0
        cashedSeekBarSeconds = 0.0
        switch playMode {
        case .shuffle:
            Task {
                guard let playingMusic = self.playingMusic else { return }
                if PlayedRepository.addPlayed(newMusicFilePaths: [playingMusic.filePath]) {
                    print("addSucceeded")
                }
                if let nextMusic = await WillPlayRepository.nextMusic() {
                    if WillPlayRepository.removeWillPlay(filePaths: [nextMusic.filePath]) {
                        print("removeSucceeded")
                    }
                    musicChoosed(music: nextMusic, playGroup: playGroup)
                } else {
                    self.playingMusic = nil
                }
            }
        case .order:
            Task {
                guard let playingMusic = self.playingMusic else { return }
                if PlayedRepository.addPlayed(newMusicFilePaths: [playingMusic.filePath]) {
                    print("addSucceeded")
                }
                if let nextMusic = await WillPlayRepository.nextMusic() {
                    if WillPlayRepository.removeWillPlay(filePaths: [nextMusic.filePath]) {
                        print("removeSucceeded")
                    }
                    musicChoosed(music: nextMusic, playGroup: playGroup)
                } else {
                    self.playingMusic = nil
                }
            }
        case .sameRepeat:
            if let music = self.playingMusic {
                musicChoosed(music: music, playGroup: playGroup)
            }
        }
    }
    
    func movePreviousMusic() {
        stop()
        seekPosition = 0.0
        cashedSeekBarSeconds = 0.0
        switch playMode {
        case .shuffle:
            Task {
                guard let playingMusic = self.playingMusic else { return }
                if WillPlayRepository.insertWillPlay(newMusicFilePaths: [playingMusic.filePath], at: 0) {
                    print("addSucceeded")
                }
                if let previousMusic = await PlayedRepository.previousMusic() {
                    if PlayedRepository.removePlayed(filePaths: [previousMusic.filePath]) {
                        print("removeSucceeded")
                    }
                    musicChoosed(music: previousMusic, playGroup: playGroup)
                } else {
                    self.playingMusic = nil
                }
            }
        case .order:
            Task {
                guard let playingMusic = self.playingMusic else { return }
                if WillPlayRepository.insertWillPlay(newMusicFilePaths: [playingMusic.filePath], at: 0) {
                    print("addSucceeded")
                }
                if let previousMusic = await PlayedRepository.previousMusic() {
                    if PlayedRepository.removePlayed(filePaths: [previousMusic.filePath]) {
                        print("removeSucceeded")
                    }
                    musicChoosed(music: previousMusic, playGroup: playGroup)
                } else {
                    self.playingMusic = nil
                }
            }
        case .sameRepeat:
            if let music = self.playingMusic {
                musicChoosed(music: music, playGroup: playGroup)
            }
        }
    }
    
    func setSeek() {
        guard let filePath = playingMusic?.filePath else { return }
        guard let fileURL = FileService.documentDirectory?.appendingPathComponent(filePath) else { return }
        guard let audioFile = try? AVAudioFile(forReading: fileURL) else { return }
        // サンプルレートを取得する
        let sampleRate = audioFile.processingFormat.sampleRate
        // 変更する秒数のSampleTimeを取得する
        let startSampleTime = AVAudioFramePosition(sampleRate * seekPosition)
        // 変更した後の曲の残り時間とそのSampleTimeを取得する(曲の秒数-変更する秒数)
        let length = playingMusic?.musicLength ?? 300 - seekPosition
        let remainSampleTime = AVAudioFrameCount(length * Double(sampleRate))
        // 変更した秒数をキャッシュしておく
        cashedSeekBarSeconds = Double(seekPosition)
        // 変更した秒数から曲を再生し直すため、AudioEngineとPlayerNodeを停止する
        stop()
        // 曲の再生秒数の変更メソッド
        playerNode.scheduleSegment(audioFile, startingFrame: startSampleTime, frameCount: remainSampleTime, at: nil)
        NotificationRepository.setNowPlayingInfo()
        // 停止状態なので再生する
        play()
    }
    
    func play() {
        // 再生処理
        do {
            try audioEngine.start()
            playerNode.play()
            NotificationRepository.setNowPlayingInfo()
            isPlaying = true
//            UserDefaults.standard.setValue(music?.musicName ?? "不明な曲", forKey: "plaingMusicName")
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pause() {
        isPlaying = false
        audioEngine.pause()
        playerNode.pause()
        NotificationRepository.setNowPlayingInfo()
    }
    
    func stop() {
        isPlaying = false
        audioEngine.stop()
        playerNode.stop()
    }
    
    func musicChoosed(music: Music, playGroup: PlayGroup) {
        self.playGroup = playGroup
        setMusic(music: music)
        setScheduleFile()
        seekPosition = 0.0
        cashedSeekBarSeconds = 0.0
        play()
        setTimer()
    }
    
    
    func setNextMusics(musicFilePaths: [String]) {
        var filePaths = musicFilePaths
        guard let filePath = playingMusic?.filePath else { return }
        guard let index = filePaths.firstIndex(of: filePath) else { return }
        filePaths.remove(at: index)
        guard PlayedRepository.cleanUpPlayed() else { return }
        guard WillPlayRepository.sortWillPlay(playMode: playMode, playGroup: playGroup) else { return }
        print("setSucceeded")
    }
    
    func setPlayMode(playMode: PlayMode) {
        self.playMode = playMode
        guard WillPlayRepository.sortWillPlay(playMode: playMode, playGroup: playGroup) else { return }
        print("sortSucceeded")
        UserDefaultsRepository.savePlayMode(playMode: playMode)
    }
    
    func changePlayMode() {
        switch playMode {
        case .shuffle:
            playMode = .order
        case .order:
            playMode = .sameRepeat
        case .sameRepeat:
            playMode = .shuffle
        }
        guard WillPlayRepository.sortWillPlay(playMode: playMode, playGroup: playGroup) else { return }
        print("sortSucceeded")
        UserDefaultsRepository.savePlayMode(playMode: playMode)
    }
}
