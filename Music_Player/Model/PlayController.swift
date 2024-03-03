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
    private var audioPlayer: AVAudioPlayer?
    @Published var music = Music(musicName: "曲名", artistName: "アーティスト名", albumName: "アルバム名", editedDate: Date(), fileSize: "0MB", filePath: "path")
    @Published var seekPosition = 0.5
    @Published var isPlay = false
    
    func setupAudioPlayer(path: String) {
        guard let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path)) else { return }
        player.delegate = self
        self.audioPlayer = player
    }
    
    func playAudioPlayer() {
        audioPlayer?.play()
    }
    
    func pauseAudioPlayer() {
        audioPlayer?.pause()
    }
}

extension PlayController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // あとで実装
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        // あとで実装
    }
}
