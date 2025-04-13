//
//  PlayService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/17.
//

//import Foundation
//import AVFoundation
//import SwiftData
//import MediaPlayer
//
//@MainActor
//class PlayController: ObservableObject {
//    static let shared = PlayController()
//    private let audioEngine: AVAudioEngine = .init()
//    private let playerNode: AVAudioPlayerNode = .init()
//    private var cachedSeekBarSeconds = 0.0
//    private var DidPlayMusicData = DidPlayMusicDataService.shared
//    @Published var didPlayMusics = [Music]()
//    @Published var willPlayMusics = [Music]()
//    @Published var music: Music? = nil
//    @Published var seekPosition: TimeInterval = 0.0
//    @Published var isPlay: Bool {
//        didSet {
//            if isPlay {
//                play()
//                setTimer()
//            } else {
//                pause()
//            }
//        }
//    }
//    @Published var timer: Timer!
//    enum playMode { case shuffle, order, sameRepeat }
//    enum playingView { case music, favorite, didPlay, artist, album, playlist, folder, willPlay }
//    
//    init() {
//        // 接続するオーディオノードをAudioEngineにアタッチする
//        audioEngine.attach(playerNode)
//        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)
//        isPlay = false
//        initRemoteCommand()
//        setNotification()
//    }
//    
//    func setMusic(music: Music) {
//        self.music = music
//        savePlayingMusic(music: music)
//    }
//    
//    func setScheduleFile() {
//        //currentItem.itemはMPMediaItemクラス
//        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
//        guard let filePath = music?.filePath else { return }
//        let fullFilePath = directoryPath + "/" + filePath
//        let fileURL = URL(fileURLWithPath: fullFilePath)
//        do {
//            // Source fileを取得する
//            let audioFile = try AVAudioFile(forReading: fileURL)
//            // PlayerNodeからAudioEngineのoutput先であるmainMixerNodeへ接続する
//            audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)
//            // 再生準備
//            playerNode.scheduleFile(audioFile, at: nil, completionCallbackType: .dataRendered)
//        }
//        catch let error {
//            print(error.localizedDescription)
//            return
//        }
//    }
//    
//    func setNextMusics(musics: [Music]) {
//        Task {
//            willPlayMusics = []
//            var musicArray = musics
//            await deleteAllWillPlayMusic()
//            let playMode = loadPlayMode()
//            switch playMode {
//            case .shuffle:
//                if let index = musicArray.firstIndex(of: music ?? Music()) {
//                    musicArray.remove(at: index)
//                    musicArray.shuffle()
//                    for i in 0 ..< musicArray.count {
//                        await createWillPlayMusic(music: musicArray[i], index: i)
//                    }
//                    await readWillPlayMusics()
//                }
//            case .order:
//                willPlayMusics = musics
//                if let index = willPlayMusics.firstIndex(of: music ?? Music()) {
//                    willPlayMusics.remove(at: index)
//                }
//                willPlayMusics.sort {$0.musicName ?? "不明" < $1.musicName ?? "不明"}
//                for i in 0 ..< willPlayMusics.count {
//                    await createWillPlayMusic(music: willPlayMusics[i], index: i)
//                }
//            case .sameRepeat:
//                break
//            }
//        }
//    }
//    
//    func setTimer() {
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
//            self.updateSeekPosition()
//        })
//    }
//    
//    func updateSeekPosition() {
//        // 最後にサンプリングしたデータを取得する ①
//        guard let nodeTime = playerNode.lastRenderTime else { return }
//        // playerNodeの時間軸に変換する ②
//        guard let playerTime = playerNode.playerTime(forNodeTime: nodeTime) else { return }
//        // サンプルレートとサンプルタイム取得する ③
//        let sampleRate = playerTime.sampleRate
//        let sampleTime = playerTime.sampleTime
//        // 秒数を取得し保持する ④
//        let time = Double(sampleTime) / sampleRate + cachedSeekBarSeconds
//        isEndOfFile()
//        seekPosition = time
//    }
//    
//    func isEndOfFile() {
//        //ファイルの長さ
//        let fileDuration = Double(music?.musicLength ?? 300)
//        //現在再生している時間
//        guard let nodeTime = playerNode.lastRenderTime else { return }
//        guard let playerTime = playerNode.playerTime(forNodeTime: nodeTime) else { return }
//        let currentTime = (Double(playerTime.sampleTime) / Double(playerTime.sampleRate)) + cachedSeekBarSeconds
//        if currentTime >= fileDuration {
//            self.moveNextMusic()
//            return
//        } else {
//            return
//        }
//    }
//    
//    func setSeek() {
//        let time = seekPosition
//        guard let filePath = music?.filePath else { return }
//        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
//        let fullFilePath = directoryPath + "/" + filePath
//        let assetURL = URL(fileURLWithPath: fullFilePath)
//        guard let audioFile = try? AVAudioFile(forReading: assetURL) else { return }
//        // サンプルレートを取得する
//        let sampleRate = audioFile.processingFormat.sampleRate
//        // 変更する秒数のSampleTimeを取得する
//        let startSampleTime = AVAudioFramePosition(sampleRate * time)
//        // 変更した後の曲の残り時間とそのSampleTimeを取得する(曲の秒数-変更する秒数)
//        let length = music?.musicLength ?? 300 - time
//        let remainSampleTime = AVAudioFrameCount(length * Double(sampleRate))
//        // 変更した秒数をキャッシュしておく
//        cachedSeekBarSeconds = Double(time)
//        // 変更した秒数から曲を再生し直すため、AudioEngineとPlayerNodeを停止する
//        stop()
//        // 曲の再生秒数の変更メソッド
//        playerNode.scheduleSegment(audioFile, startingFrame: startSampleTime, frameCount: remainSampleTime, at: nil)
//        setNowPlayingInfo()
//        // 停止状態なので再生する
//        isPlay = true
//    }
//    
//    func play() {
//        do {
//            // 再生処理
//            try audioEngine.start()
//            playerNode.play()
//            UserDefaults.standard.setValue(music?.musicName ?? "不明な曲", forKey: "plaingMusicName")
//            setNowPlayingInfo()
//        }
//        catch let error {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func pause() {
//        audioEngine.pause()
//        playerNode.pause()
//        setNowPlayingInfo()
//    }
//    
//    func stop() {
//        audioEngine.stop()
//        playerNode.stop()
//    }
//    
//    func musicChoosed(music: Music, musics: [Music]) {
//        Task {
//            setMusic(music: music)
//            setScheduleFile()
//            setNextMusics(musics: musics)
//            seekPosition = 0.0
//            cachedSeekBarSeconds = 0.0
//            isPlay = true
//            setTimer()
//            await createDidPlayMusic(music: music)
//            await readDidPlayMusics()
//        }
//    }
//    
//    func randomPlay(musics: [Music]) {
//        if !musics.isEmpty {
//            musicChoosed(music: musics.randomElement()!, musics: musics)
//        }
//    }
//    
//    func choosedWillPlayMusic(music: Music) {
//        Task {
//            for willPlayMusic in willPlayMusics {
//                await deleteWillPlayMusic(music: willPlayMusic)
//                await readWillPlayMusics()
//                await createDidPlayMusic(music: willPlayMusic)
//                await readDidPlayMusics()
//                if willPlayMusic == music {
//                    setMusic(music: willPlayMusic)
//                    setScheduleFile()
//                    savePlayingMusic(music: willPlayMusic)
//                    isPlay = true
//                    setTimer()
//                    break
//                }
//            }
//        }
//    }
//    
//    func choosedDidPlayMusic(music: Music) {
//        Task {
//            for didPlayMusic in didPlayMusics {
//                await deleteDidPlayMusic(music: didPlayMusic)
//                await readDidPlayMusics()
//                willPlayMusics = await insertFirst(music: didPlayMusic)
//                if didPlayMusic == music {
//                    setMusic(music: didPlayMusic)
//                    setScheduleFile()
//                    savePlayingMusic(music: didPlayMusic)
//                    isPlay = true
//                    setTimer()
//                    break
//                }
//            }
//        }
//    }
//    
//    func moveNextMusic() {
//        pause()
//        seekPosition = 0.0
//        cachedSeekBarSeconds = 0.0
//        Task {
//            if let music = self.music {
//                if let music = willPlayMusics.first {
//                    if loadPlayMode() != .sameRepeat {
//                        await createDidPlayMusic(music: music)
//                        await readDidPlayMusics()
//                        setMusic(music: music)
//                        await deleteWillPlayMusic(music: music)
//                        await readWillPlayMusics()
//                        setScheduleFile()
//                        isPlay = true
//                        setTimer()
//                    } else {
//                        setScheduleFile()
//                        isPlay = true
//                        setTimer()
//                    }
//                } else {
//                    self.music = nil
//                    UserDefaults.standard.removeObject(forKey: "playingMusicDictionary")
//                    stop()
//                    isPlay = false
//                }
//            }
//        }
//    }
//    
//    func moveBeforeMusic() {
//        pause()
//        seekPosition = 0.0
//        cachedSeekBarSeconds = 0.0
//        if let music = self.music {
//            if didPlayMusics.count > 1 {
//                Task {
//                    willPlayMusics = await insertFirst(music: music)
//                    savePlayingMusic(music: didPlayMusics[1])
//                    setMusic(music: didPlayMusics[1])
//                    await deleteDidPlayMusic(music: didPlayMusics.first!)
//                    await readDidPlayMusics()
//                    setScheduleFile()
//                    isPlay = true
//                    setTimer()
//                }
//            } else {
//                Task {
//                    await deleteAllDidPlayMusic()
//                    await readDidPlayMusics()
//                    self.music = nil
//                    UserDefaults.standard.removeObject(forKey: "playingMusicDictionary")
//                    stop()
//                    isPlay = false
//                }
//            }
//        }
//    }
//    
//    func addWPMFirst(music: Music) {
//        willPlayMusics.insert(music, at: 0)
//    }
//    
//    func addWPMLast(music: Music) {
//        willPlayMusics.append(music)
//    }
//    
//    func changePlayMode() {
//        let nowPlayMode = loadPlayMode()
//        switch nowPlayMode {
//        case .shuffle:
//            savePlayMode(playMode: .order)
//            willPlayMusics.sort {$0.musicName ?? "不明" < $1.musicName ?? "不明"}
//        case .order:
//            savePlayMode(playMode: .sameRepeat)
//            willPlayMusics = []
//        case .sameRepeat:
//            Task {
//                savePlayMode(playMode: .shuffle)
//                await readWillPlayMusics()
//            }
//        }
//    }
//    
//    func orderSort() -> Array<Music> {
//        var musics = willPlayMusics
//        musics.append(music ?? Music())
//        musics.sort {$0.musicName ?? "不明な曲" < $1.musicName ?? "不明な曲"}
//        if let index = musics.firstIndex(of: music ?? Music()) {
//            for i in 0 ..< index {
//                let music = musics.first
//                musics.removeFirst()
//                musics.append(music!)
//            }
//        }
//        musics.removeFirst()
//        return musics
//    }
//    
//    func savePlayMode(playMode: playMode) {
//        let userDefaults = UserDefaults.standard
//        switch playMode {
//        case .shuffle:
//            userDefaults.setValue("shuffle", forKey: "playMode")
//        case .order:
//            userDefaults.setValue("order", forKey: "playMode")
//        case .sameRepeat:
//            userDefaults.setValue("sameRepeat", forKey: "playMode")
//        }
//    }
//    
//    func createWillPlayMusic(music: Music, index: Int) async {
//        await WillPlayMusicDataService.shared.createWillPlayMusicData(music: music, index: index)
//    }
//    
//    func insertFirst(music: Music) async -> [Music] {
//        return await WillPlayMusicDataService.shared.insertFirst(music: music)
//    }
//    
//    func readWillPlayMusics() async {
//        willPlayMusics = await WillPlayMusicDataService.shared.readWillPlayMusics()
//    }
//    
//    func updateWillPlayMusicData(oldMusic: Music, newMusic: Music) async {
//        await WillPlayMusicDataService.shared.updateWillPlayMusicData(oldMusic: oldMusic, newMusic: newMusic)
//    }
//    
//    func deleteWillPlayMusic(music: Music) async {
//        await WillPlayMusicDataService.shared.deleteWillPlayMusicData(music: music)
//    }
//    
//    func deleteAllWillPlayMusic() async {
//        await WillPlayMusicDataService.shared.deleteAllWillPlayMusicData()
//    }
//    
//    func createDidPlayMusic(music: Music) async {
//        await DidPlayMusicDataService.shared.createDidPlayMusicData(music: music)
//    }
//    
//    func readDidPlayMusics() async {
//        didPlayMusics = await DidPlayMusicDataService.shared.readDidPlayMusics()
//    }
//    
//    func deleteDidPlayMusic(music: Music) async {
//        await DidPlayMusicDataService.shared.deleteDidPlayMusicData(music: music)
//    }
//    
//    func deleteAllDidPlayMusic() async {
//        await DidPlayMusicDataService.shared.deleteAllDidPlayMusicDatas()
//    }
//    
//    func loadPlayMode() -> playMode {
//        let saveData = UserDefaults.standard.string(forKey: "playMode") ?? "shuffle"
//        var playMode: playMode = .shuffle
//        switch saveData {
//        case "shuffle":
//            playMode = .shuffle
//        case "order":
//            playMode = .order
//        case "sameRepeat":
//            playMode = .sameRepeat
//        default:
//            break
//        }
//        return playMode
//    }
//    
//    func savePlayingMusic(music: Music?) {
//        if let saveMusic = music {
//            let musicDictionary: [String: Any] = ["musicName": saveMusic.musicName ?? "不明な曲", "artistName": saveMusic.artistName ?? "不明なアーティスト", "albumName": saveMusic.albumName ?? "不明なアルバム", "editedDate": saveMusic.editedDate ?? Date(), "fileSize": saveMusic.fileSize ?? "0MB", "musicLength": saveMusic.musicLength ?? 0.0, "filePath": saveMusic.filePath ?? "不明なパス"]
//            UserDefaults.standard.setValue(musicDictionary, forKey: "playingMusicDictionary")
//        }
//    }
//    
//    func loadPlayingMusic() -> Music? {
//        if let musicDictionary = UserDefaults.standard.dictionary(forKey: "playingMusicDictionary") {
//            let music = Music(musicName: musicDictionary["musicName"] as? String, artistName: musicDictionary["artistName"] as? String, albumName: musicDictionary["albumName"] as? String, editedDate: musicDictionary["editedDate"] as? Date, fileSize: musicDictionary["fileSize"] as? String, musicLength: musicDictionary["musicLength"] as? TimeInterval, filePath: musicDictionary["filePath"] as? String)
//            return music
//        }
//        return nil
//    }
//    
//    func setPlayingMusic() {
//        if let music = loadPlayingMusic() {
//            if checkImaginaryMusics(music: music) {
//                setMusic(music: music)
//            } else {
//                self.music = nil
//            }
//            Task {
//                await readWillPlayMusics()
//                var willMusics = [Music]()
//                for willPlayMusic in willPlayMusics {
//                    if checkImaginaryMusics(music: willPlayMusic) {
//                        willMusics.append(willPlayMusic)
//                    }
//                }
//                await deleteAllWillPlayMusic()
//                for i in 0 ..< willMusics.count {
//                    let item = willMusics[i]
//                    await createWillPlayMusic(music: item, index: i)
//                }
//                await readWillPlayMusics()
//                
//                await readDidPlayMusics()
//                var didMusics = [Music]()
//                for didPlayMusic in didPlayMusics {
//                    if checkImaginaryMusics(music: didPlayMusic) {
//                        didMusics.append(didPlayMusic)
//                    }
//                }
//                await deleteAllDidPlayMusic()
//                for i in 0 ..< didMusics.count {
//                    let item = didMusics[i]
//                    await createDidPlayMusic(music: item)
//                }
//                await readDidPlayMusics()
//            }
//        }
//    }
//    
//    func checkImaginaryMusics(music: Music) -> Bool {
//        guard let filePath = music.filePath else { return false }
//        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
//        let fullFilePath = directoryPath + "/" + filePath
//        let isExsist = FileManager.default.fileExists(atPath: fullFilePath)
//        if isExsist { return true }
//        else { return false }
//    }
//    
//    func timerForSleep(interval: TimeInterval) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
//            self.isPlay = false
//        }
//    }
//
//    func setNowPlayingInfo() {
//        let center = MPNowPlayingInfoCenter.default()
//        var nowPlayingInfo = center.nowPlayingInfo ?? [String : Any]()
//        
//        // タイトル
//        nowPlayingInfo[MPMediaItemPropertyTitle] = music?.musicName
//        nowPlayingInfo[MPMediaItemPropertyArtist] = music?.artistName
//        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = music?.albumName
//        // サムネ
//        //        nowPlayingInfo[MPMediaItemPropertyArtwork] = UIImage(systemName: "music.note")
//        // 再生位置
//        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = String(seekPosition)
//        // 現在の再生時間
//        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = String(music?.musicLength ?? 300)
//        // 曲の速さ
//        if isPlay {
//            guard let filePath = music?.filePath else { return }
//            let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
//            let fullFilePath = directoryPath + "/" + filePath
//            let assetURL = URL(fileURLWithPath: fullFilePath)
//            guard let audioFile = try? AVAudioFile(forReading: assetURL) else { return }
//            let sampleRate = audioFile.processingFormat.sampleRate
//            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
//        } else {
//            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
//        }
//        
//        // メタデータを設定する
//        center.nowPlayingInfo = nowPlayingInfo
//    }
//    
//    func initRemoteCommand() {
//        // 再生ボタン
//        let commandCenter = MPRemoteCommandCenter.shared()
//        commandCenter.playCommand.removeTarget(self)
//        commandCenter.playCommand.isEnabled = true
//        commandCenter.playCommand.addTarget { [unowned self] event in
//            isPlay = true
//            return .success
//        }
//        // 一時停止ボタン
//        commandCenter.pauseCommand.removeTarget(self)
//        commandCenter.pauseCommand.isEnabled = true
//        commandCenter.pauseCommand.addTarget { [unowned self] event in
//            isPlay = false
//            return .success
//        }
//        // 前の曲ボタン
//        commandCenter.previousTrackCommand.removeTarget(self)
//        commandCenter.previousTrackCommand.isEnabled = true
//        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
//            moveBeforeMusic()
//            return .success
//        }
//        // 次の曲ボタン
//        commandCenter.nextTrackCommand.removeTarget(self)
//        commandCenter.nextTrackCommand.isEnabled = true
//        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
//            moveNextMusic()
//            return .success
//        }
//        // シークバーでの秒数変更
//        commandCenter.changePlaybackPositionCommand.removeTarget(self)
//        commandCenter.changePlaybackPositionCommand.isEnabled = true
//        commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
//            guard let positionCommandEvent = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
//            seekPosition = Double(positionCommandEvent.positionTime)
//            setSeek()
//            return .success
//        }
//    }
//    
//    func setNotification() {
//        NotificationCenter.default.addObserver(self, selector: #selector(onInterruption(_:)), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
//        NotificationCenter.default.addObserver(self, selector: #selector(onAudioSessionRouteChanged(_:)), name: AVAudioSession.routeChangeNotification, object: nil)
//    }
//    
//    @objc func onInterruption(_ notification: Notification) {
//        guard let userInfo = notification.userInfo,
//              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
//              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
//            return
//        }
//        switch type {
//        case .began:
//            if isPlay {
//                pause()
//            }
//            break
//        case .ended:
//            if !isPlay {
//                play()
//            }
//            break
//        @unknown default:
//            break
//        }
//    }
//    
//    @objc func onAudioSessionRouteChanged(_ notification: Notification) {
//        guard let userInfo = notification.userInfo,
//              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
//              let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
//            return
//        }
//        
//        switch reason {
//        case .newDeviceAvailable:
//            if !isPlay {
//                play()
//            }
//        case .oldDeviceUnavailable:
//            if isPlay {
//                pause()
//            }
//        default:
//            break
//        }
//    }
//}
