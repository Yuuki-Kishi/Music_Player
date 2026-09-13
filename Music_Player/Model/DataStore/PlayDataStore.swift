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
    @Published var seekPositionUpdateTimer: Timer?
    @Published var cashedSeekBarSeconds: Double = 0.0
    @Published var isPlaying: Bool = false
    @Published var isShowPlayView: Bool = false
    @Published var isShowAddPlaylistView: Bool = false
    @Published var isShuffle: Bool = false
    @Published var repeatMode: RepeatModeEnum = .off
    @Published var audioEngine: AVAudioEngine = AVAudioEngine()
    @Published var playerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    @Published var equalizerNode: AVAudioUnitEQ = AVAudioUnitEQ(numberOfBands: 10)
    @Published var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    enum RepeatModeEnum: String {
        case all, one, off
    }
    
    init() {
        // 接続するオーディオノードをAudioEngineにアタッチする
        try? audioSession.setCategory(.playback)
        audioEngine.attach(playerNode)
        audioEngine.attach(equalizerNode)
        audioEngine.connect(playerNode, to: equalizerNode, format: nil)
        audioEngine.connect(equalizerNode, to: audioEngine.mainMixerNode, format: nil)
        NotificationRepository.initRemoteCommand()
        NotificationRepository.setNotification()
    }
}
