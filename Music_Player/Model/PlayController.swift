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
    private var cachedSeekBarSeconds = 0.0
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
    @Published var timer: Timer!
    enum playModeEnum: String {
        case shuffle
        case order
        case sameRepeat
    }
    
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
//        UserDefaults.standard.setValue(playModeEnum.rawValue, forKey: "playMode")
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
            playerNode.scheduleFile(audioFile, at: nil, completionCallbackType: .dataRendered) /*{ _ in*/
//                if self.isEndOfFile() ?? false {
//                    DispatchQueue.main.async {
//                        self.moveNextMusic()
//                    }
//                }
//            }
        }
        catch let error {
            print(error.localizedDescription)
            return
        }
    }
    
    func isEndOfFile() {
        guard let filePath = music?.filePath else { return }
        let assetURL = URL(fileURLWithPath: filePath)
        guard let audioFile = try? AVAudioFile(forReading: assetURL) else { return }
        //ファイルの長さ
        let fileDuration = Double(music?.musicLength ?? 300)
        //現在再生している時間
        guard let nodeTime = playerNode.lastRenderTime else { return }
        guard let playerTime = playerNode.playerTime(forNodeTime: nodeTime) else { return }
        let currentTime = (Double(playerTime.sampleTime) / Double(playerTime.sampleRate)) + cachedSeekBarSeconds
        
        if currentTime >= fileDuration {
            self.moveNextMusic()
            return
        } else {
            return
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
        let time = Double(sampleTime) / sampleRate + cachedSeekBarSeconds
        isEndOfFile()
        seekPosition = time
    }
    
    func setSeek() {
        let time = seekPosition
        guard let filePath = music?.filePath else { return }
        let assetURL = URL(fileURLWithPath: filePath)
        guard let audioFile = try? AVAudioFile(forReading: assetURL) else { return }
        // サンプルレートを取得する
        let sampleRate = audioFile.processingFormat.sampleRate
        // 変更する秒数のSampleTimeを取得する
        let startSampleTime = AVAudioFramePosition(sampleRate * time)
        // 変更した後の曲の残り時間とそのSampleTimeを取得する(曲の秒数-変更する秒数)
        let length = music?.musicLength ?? 300 - time
        let remainSampleTime = AVAudioFrameCount(length * Double(sampleRate))
        // 変更した秒数をキャッシュしておく
        cachedSeekBarSeconds = Double(time)
        // 変更した秒数から曲を再生し直すため、AudioEngineとPlayerNodeを停止する
        stop()
        // 曲の再生秒数の変更メソッド
        playerNode.scheduleSegment(audioFile, startingFrame: startSampleTime, frameCount: remainSampleTime, at: nil)
        // 停止状態なので再生する
        isPlay = true
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
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
        cachedSeekBarSeconds = 0.0
        if let music = willPlayMusics.first {
            if loadPlayMode() != .sameRepeat {
                setMusic(music: music)
                willPlayMusics.removeFirst()
                setScheduleFile()
                isPlay = true
                setTimer()
            } else {
                setScheduleFile()
                isPlay = true
                setTimer()
            }
        } else {
            music = nil
            stop()
            isPlay = false
        }
    }
    
    func musicChoosed(music: Music, musicArray: [Music]) {
        setMusic(music: music)
        setScheduleFile()
        setNextMusics(playMode: .shuffle, musicArray: musicArray)
        isPlay = true
        setTimer()
    }
    
    func changePlayMode() {
        let nowPlayMode = loadPlayMode()
        switch nowPlayMode {
        case .shuffle:
            savePlayMode(playMode: .order)
            willPlayMusics.sort {$0.musicName < $1.musicName}
        case .order:
            savePlayMode(playMode: .sameRepeat)
            break
        case .sameRepeat:
            savePlayMode(playMode: .shuffle)
            willPlayMusics.shuffle()
        }
    }
    
    func savePlayMode(playMode: playModeEnum) {
        let userDefaults = UserDefaults.standard
        switch playMode {
        case .shuffle:
            userDefaults.setValue("shuffle", forKey: "playMode")
        case .order:
            userDefaults.setValue("order", forKey: "playMode")
        case .sameRepeat:
            userDefaults.setValue("sameRepeat", forKey: "playMode")
        }
    }
    
    func loadPlayMode() -> playModeEnum {
        let saveData = UserDefaults.standard.string(forKey: "playMode") ?? "shuffle"
        var playMode: playModeEnum = .shuffle
        switch saveData {
        case "shuffle":
            playMode = .shuffle
        case "order":
            playMode = .order
        case "sameRepeat":
            playMode = .sameRepeat
        default:
            break
        }
        return playMode
    }
}
