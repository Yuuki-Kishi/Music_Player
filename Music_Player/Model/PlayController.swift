//
//  PlayService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/17.
//

import Foundation
import AVFoundation

@MainActor
class PlayController: ObservableObject {
    static let shared = PlayController()
    private let audioEngine: AVAudioEngine = .init()
    private let playerNode: AVAudioPlayerNode = .init()
    @Published var didPlayMusics = [Music]()
    @Published var willPlayMusics = [Music]()
    @Published var music: Music? = nil
    @Published var seekPosition: TimeInterval = 0.0
    @Published var isPlay: Bool {
        didSet {
            if isPlay {
                play()
                setTimer()
            } else {
                pause()
            }
        }
    }
    @Published var isAutoProceduleOn: Bool = true
    enum playModeEnum {
        case shuffle, order, sameRepeat
    }
    var timer: Timer!
    
    init() {
        // 接続するオーディオノードをAudioEngineにアタッチする
        audioEngine.attach(playerNode)
        isPlay = false
    }
    
    func setMusic(music: Music) {
        self.music = music
        didPlayMusics.append(music)
    }
    
    func setNextMusics(playMode: playModeEnum, musicArray: [Music]) {
        willPlayMusics = []
        switch playMode {
        case .shuffle:
            willPlayMusics = musicArray
            let index = willPlayMusics.firstIndex(of: music!)!
            willPlayMusics.remove(at: index)
            willPlayMusics.shuffle()
        case .order:
            willPlayMusics = musicArray
            let index = willPlayMusics.firstIndex(of: music!)!
            willPlayMusics.remove(at: index)
        case .sameRepeat:
            break
        }
    }
    
    func setScheduleFile() {
        // 楽曲のURLを取得する
        // currentItem.itemはMPMediaItemクラス
        guard let filePath = music?.filePath else { return }
        let assetURL = URL(fileURLWithPath: filePath)
        do {
            // Source fileを取得する
            let audioFile = try AVAudioFile(forReading: assetURL)
            // PlayerNodeからAudioEngineのoutput先であるmainMixerNodeへ接続する
            audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)
            // 再生準備
            playerNode.scheduleFile(audioFile, at: nil, completionCallbackType: .dataRendered) { _ in
                if self.isAutoProceduleOn {
                    DispatchQueue.main.async {
                        self.moveNextMusic()
                    }
                }
            }
        }
        catch let error {
            print(error.localizedDescription)
            return
        }
    }
    
    func isEndOfFile() -> Bool? {
        guard let filePath = music?.filePath else { return nil }
        let assetURL = URL(fileURLWithPath: filePath)
        guard let audioFile = try? AVAudioFile(forReading: assetURL) else { return nil }
        //ファイルの長さ
        let fileDuration = Double(audioFile.length) / audioFile.fileFormat.sampleRate
        //現在再生している時間
        guard let nodeTime = playerNode.lastRenderTime else { return nil }
        guard let playerTime = playerNode.playerTime(forNodeTime: nodeTime) else { return nil }
        let currentTime = Double(playerTime.sampleRate) / Double(playerTime.sampleTime)
        
        if currentTime >= fileDuration {
            return true
        } else {
            return false
        }
    }
    
    func updateSeekPosition() {
        // 最後にサンプリングしたデータを取得する ①
        guard let nodeTime = playerNode.lastRenderTime else { return }
        // playerNodeの時間軸に変換する ②
        guard let playerTime = playerNode.playerTime(forNodeTime: nodeTime) else { return }
        // サンプルレートとサンプルタイム取得する ③
        let sampleRate = playerTime.sampleRate
        let sampleTime = playerTime.sampleTime
        // 秒数を取得し保持する ④
        let time = Double(sampleTime) / sampleRate
        seekPosition = time
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            self.updateSeekPosition()
        })
    }
    
    func play() {
        do {
            // 再生処理
            try audioEngine.start()
            playerNode.play()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pause() {
        audioEngine.pause()
        playerNode.pause()
    }
    
    func stop() {
        audioEngine.stop()
        playerNode.stop()
    }
    
    func moveNextMusic() {
        seekPosition = 0.0
        if let music = willPlayMusics.first {
            isAutoProceduleOn = isEndOfFile() ?? false
            setMusic(music: music)
            willPlayMusics.removeFirst()
            setScheduleFile()
            isPlay = true
            setTimer()
            isAutoProceduleOn = true
        } else {
            music = nil
            stop()
            isPlay = false
        }
    }
    
    func musicChoosed(music: Music, musicArray: [Music]) {
        isAutoProceduleOn = isEndOfFile() ?? false
        setMusic(music: music)
        setScheduleFile()
        setNextMusics(playMode: .shuffle, musicArray: musicArray)
        isPlay = true
        setTimer()
        isAutoProceduleOn = true
    }
}
