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
    @Published var seekPosition = 0.5
    @Published var isPlay: Bool {
        didSet {
            if isPlay {
                play()
            } else {
                pause()
            }
        }
    }
    enum playModeEnum {
        case shuffle, order, sameRepeat
    }
    
    init() {
        // 接続するオーディオノードをAudioEngineにアタッチする
        audioEngine.attach(playerNode)
        isPlay = false
    }
    
    func setMusic(music: Music) {
        self.music = music
    }
    
    func setNextMusics(playMode: playModeEnum, musicArray: [Music]) {
        var musics = musicArray
        willPlayMusics = []
        switch playMode {
        case .shuffle:
            let index = musics.firstIndex(of: music!)!
            musics.remove(at: index)
            for i in 0 ..< musics.count {
                let random = Int.random(in: 0 ..< musics.count)
                willPlayMusics.append(musics[random])
                musics.remove(at: random)
            }
        case .order:
            break
        case .sameRepeat:
            break
        }
    }
    
    func setScheduleFile() -> Bool {
        // 楽曲のURLを取得する
        // currentItem.itemはMPMediaItemクラス
        guard let filePath = music?.filePath else { return false }
        let assetURL = URL(fileURLWithPath: filePath)
        do {
            // Source fileを取得する
            let audioFile = try AVAudioFile(forReading: assetURL)
            // PlayerNodeからAudioEngineのoutput先であるmainMixerNodeへ接続する
            audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)//ここで落ちる
            // 再生準備
            playerNode.scheduleFile(audioFile, at: nil) {
                self.moveNextMusic()
            }
            return true
        }
        catch let error {
            print(error.localizedDescription)
            return false
        }
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
        didPlayMusics.append(music!)
        setMusic(music: willPlayMusics.first!)
        willPlayMusics.removeFirst()
        setScheduleFile()
        isPlay = true
    }
}
