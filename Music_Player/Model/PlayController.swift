//
//  PlayService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/17.
//

import Foundation
import AVFoundation
import SwiftData

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
    enum playMode { case shuffle, order, sameRepeat }
    enum playingView { case music, favorite, didPlay, artist, album, playlist, folder, willPlay }
    
    init() {
        // 接続するオーディオノードをAudioEngineにアタッチする
        audioEngine.attach(playerNode)
        isPlay = false
    }
    
    func setMusic(music: Music) {
        self.music = music
        didPlayMusics.append(music)
        let didPlayMusic = DPMD(musicName: music.musicName, artistName: music.artistName, albumName: music.albumName, editedDate: music.editedDate, fileSize: music.fileSize, musicLength: music.musicLength, filePath: music.filePath)
    }
    
    func setNextMusics(musicArray: [Music]) {
        willPlayMusics = []
        let playMode = loadPlayMode()
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
            playerNode.scheduleFile(audioFile, at: nil, completionCallbackType: .dataRendered)
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
            UserDefaults.standard.setValue(music?.musicName!, forKey: "plaingMusicName")
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
            UserDefaults.standard.removeObject(forKey: "plaingMusicName")
            stop()
            isPlay = false
        }
    }
    
    func moveBeforeMusic() {
        seekPosition = 0.0
        cachedSeekBarSeconds = 0.0
        guard let nowMusic = music else { return }
        if didPlayMusics.count >= 2 {
            let music = didPlayMusics[1]
            if loadPlayMode() != .sameRepeat {
                willPlayMusics.insert(nowMusic, at: 0)
                setMusic(music: music)
                didPlayMusics.removeLast()
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
    
    func playAll(musicArray: [Music], playingView: playingView) {
        
    }
    
    func musicChoosed(music: Music, musicArray: [Music], playingView: playingView) {
        setMusic(music: music)
        setScheduleFile()
        setNextMusics(musicArray: musicArray)
        savePlayingView(playingView: playingView)
        isPlay = true
        setTimer()
    }
    
    func addWPMFirst(music: Music) {
        willPlayMusics.insert(music, at: 0)
    }
    
    func addWPMLast(music: Music) {
        willPlayMusics.append(music)
    }
    
    func changePlayMode() {
        let nowPlayMode = loadPlayMode()
        switch nowPlayMode {
        case .shuffle:
            savePlayMode(playMode: .order)
            willPlayMusics = orderSort()
        case .order:
            savePlayMode(playMode: .sameRepeat)
            break
        case .sameRepeat:
            savePlayMode(playMode: .shuffle)
            willPlayMusics.shuffle()
        }
    }
    
    func orderSort() -> Array<Music> {
        var musics = willPlayMusics
        musics.append(music!)
        musics.sort {$0.musicName! < $1.musicName!}
        let index = musics.firstIndex(of: music!)!
        for i in 0 ..< index {
            let music = musics.first
            musics.removeFirst()
            musics.append(music!)
        }
        musics.removeFirst()
        return musics
    }
    
    func savePlayMode(playMode: playMode) {
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
    
    func loadPlayMode() -> playMode {
        let saveData = UserDefaults.standard.string(forKey: "playMode") ?? "shuffle"
        var playMode: playMode = .shuffle
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
    
    func savePlayingView(playingView: playingView) {
        let userDefaults = UserDefaults.standard
        switch playingView {
        case .music:
            userDefaults.setValue("music", forKey: "playingView")
        case .favorite:
            userDefaults.setValue("favorite", forKey: "playingView")
        case .didPlay:
            userDefaults.setValue("didPlay", forKey: "playingView")
        case .artist:
            userDefaults.setValue("artist", forKey: "playingView")
        case .album:
            userDefaults.setValue("album", forKey: "playingView")
        case .playlist:
            userDefaults.setValue("playlist", forKey: "playingView")
        case .folder:
            userDefaults.setValue("folder", forKey: "playingView")
        case .willPlay:
            userDefaults.setValue("willPlay", forKey: "playingView")
        }
    }
    
    func loadPlayingView() -> playingView {
        let saveData = UserDefaults.standard.string(forKey: "playingView") ?? "music"
        var playingView: playingView = .music
        switch saveData {
        case "music":
            playingView = .music
        case "favorite":
            playingView = .favorite
        case "didPlay":
            playingView = .didPlay
        case "artist":
            playingView = .artist
        case "album":
            playingView = .album
        case "playlist":
            playingView = .playlist
        case "folder":
            playingView = .folder
        case "willPlay":
            playingView = .willPlay
        default:
            break
        }
        return playingView
    }
    
    func setPlayingMusic(musicArray: [Music]) {
        if let musicName = UserDefaults.standard.string(forKey: "plaingMusicName") {
            if let music = musicArray.first(where: {$0.musicName == musicName}) {
                setMusic(music: music)
                setScheduleFile()
                setNextMusics(musicArray: musicArray)
            }
        }
    }
}
