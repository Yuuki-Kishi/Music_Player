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
    @Published var playMusics = [Music]()
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
    
    init() {
        // 接続するオーディオノードをAudioEngineにアタッチする
        audioEngine.attach(playerNode)
        isPlay = false
    }
    
    func setMusic(music: Music) {
        self.music = music
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
            audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)
            // 再生準備
            playerNode.scheduleFile(audioFile, at: nil)
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
}
