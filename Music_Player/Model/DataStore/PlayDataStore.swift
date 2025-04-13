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
        loadNextMusic()
        playMode = UserDefaultsRepository.loadPlayMode()
        NotificationRepository.initRemoteCommand()
        NotificationRepository.setNotification()
        stop()
    }
    
    func setMusic(music: Music) {
        self.playingMusic = music
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
    
    func loadNextMusic() {
        Task {
            if let playingMusicFilePath = UserDefaultsRepository.loadPlayingMusicFilePath() {
                if FileService.isExistFile(filePath: playingMusicFilePath) {
                    let music = await FileService.getFileMetadata(filePath: playingMusicFilePath)
                    setMusic(music: music)
                    setScheduleFile()
                    setTimer()
                    return
                } else {
                    if let music = await WillPlayRepository.nextMusic() {
                        setMusic(music: music)
                        setScheduleFile()
                        setTimer()
                        return
                    }
                }
            }
            self.playingMusic = nil
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
                guard PlayedRepository.addPlayed(newMusicFilePath: playingMusic.filePath) else { return }
                print("addSucceeded")
                if let nextMusic = await WillPlayRepository.nextMusic() {
                    guard WillPlayRepository.removeWillPlay(filePath: nextMusic.filePath) else { return }
                    print("removeSucceeded")
                    musicChoosed(music: nextMusic, playGroup: playGroup)
                } else {
                    seekPosition = 0.0
                    self.playingMusic = nil
                }
            }
        case .order:
            Task {
                guard let playingMusic = self.playingMusic else { return }
                guard PlayedRepository.addPlayed(newMusicFilePath: playingMusic.filePath) else { return }
                print("addSucceeded")
                if let nextMusic = await WillPlayRepository.nextMusic() {
                    guard WillPlayRepository.removeWillPlay(filePath: nextMusic.filePath) else { return }
                    print("removeSucceeded")
                    musicChoosed(music: nextMusic, playGroup: playGroup)
                } else {
                    seekPosition = 0.0
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
                guard WillPlayRepository.insertWillPlay(newMusicFilePath: playingMusic.filePath, at: 0) else { return }
                print("addSucceeded")
                if let previousMusic = await PlayedRepository.previousMusic() {
                    guard PlayedRepository.removePlayed(filePath: previousMusic.filePath) else { return }
                    print("removeSucceeded")
                    musicChoosed(music: previousMusic, playGroup: playGroup)
                } else {
                    seekPosition = 0.0
                    self.playingMusic = nil
                }
            }
        case .order:
            Task {
                guard let playingMusic = self.playingMusic else { return }
                guard WillPlayRepository.insertWillPlay(newMusicFilePath: playingMusic.filePath, at: 0) else { return }
                print("addSucceeded")
                if let previousMusic = await PlayedRepository.previousMusic() {
                    guard PlayedRepository.removePlayed(filePath: previousMusic.filePath) else { return }
                    print("removeSucceeded")
                    musicChoosed(music: previousMusic, playGroup: playGroup)
                } else {
                    seekPosition = 0.0
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
        if FileService.isExistFile(filePath: music.filePath) {
            self.playGroup = playGroup
            setMusic(music: music)
            UserDefaultsRepository.savePlayingMusicFilePath(filePath: music.filePath)
            setScheduleFile()
            seekPosition = 0.0
            cashedSeekBarSeconds = 0.0
            play()
            setTimer()
        } else {
            Task {
                switch playGroup {
                case .music:
                    MusicDataStore.shared.musicArray = await MusicRepository.getMusics()
                    guard let music = MusicDataStore.shared.musicArray.randomElement() else { return }
                    musicChoosed(music: music, playGroup: .music)
                case .artist:
                    guard let artistName = ArtistDataStore.shared.selectedArtist?.artistName else { return }
                    ArtistDataStore.shared.artistMusicArray = await ArtistRepository.getArtistMusic(artistName: artistName)
                    guard let music = ArtistDataStore.shared.artistMusicArray.randomElement() else { return }
                    musicChoosed(music: music, playGroup: .artist)
                case .album:
                    guard let albumName = AlbumDataStore.shared.selectedAlbum?.albumName else { return }
                    AlbumDataStore.shared.albumMusicArray = await AlbumRepository.getAlbumMusic(albumName: albumName)
                    guard let music = AlbumDataStore.shared.albumMusicArray.randomElement() else { return }
                    musicChoosed(music: music, playGroup: .album)
                case .playlist:
                    guard let filePath = PlaylistDataStore.shared.selectedPlaylist?.filePath else { return }
                    PlaylistDataStore.shared.playlistMusicArray = await PlaylistRepository.getPlaylistMusic(filePath: filePath)
                    guard let music = PlaylistDataStore.shared.playlistMusicArray.randomElement() else { return }
                    musicChoosed(music: music, playGroup: .playlist)
                case .folder:
                    guard let folderPath = FolderDataStore.shared.selectedFolder?.folderPath else { return }
                    FolderDataStore.shared.folderMusicArray = await FolderRepository.getFolderMusic(folderPath: folderPath)
                    guard let music = FolderDataStore.shared.folderMusicArray.randomElement() else { return }
                    musicChoosed(music: music, playGroup: .folder)
                case .favorite:
                    FavoriteMusicDataStore.shared.favoriteMusicArray = await FavoriteMusicRepository.getFavoriteMusics()
                    guard let music = FavoriteMusicDataStore.shared.favoriteMusicArray.randomElement() else { return }
                    musicChoosed(music: music, playGroup: .favorite)
                }
            }
        }
    }
    
    func moveChoosedMusic(music: Music) async {
        if FileService.isExistFile(filePath: music.filePath) {
            setMusic(music: music)
            UserDefaultsRepository.savePlayingMusicFilePath(filePath: music.filePath)
            setScheduleFile()
            seekPosition = 0.0
            cashedSeekBarSeconds = 0.0
            play()
            setTimer()
        } else {
            if let nextMusic = await WillPlayRepository.nextMusic() {
                print(nextMusic)
                guard WillPlayRepository.removeWillPlay(filePath: nextMusic.filePath) else { return }
                await moveChoosedMusic(music: nextMusic)
            } else {
                self.playingMusic = nil
            }
        }
    }
    
    func setNextMusics(musicFilePaths: [String]) {
        var filePaths = musicFilePaths
        guard let filePath = playingMusic?.filePath else { return }
        guard let index = filePaths.firstIndex(of: filePath) else { return }
        filePaths.remove(at: index)
        switch playMode {
        case .shuffle:
            filePaths.shuffle()
        case .order:
            filePaths.sort { $0 < $1 }
        case .sameRepeat:
            filePaths = []
        }
        guard PlayedRepository.cleanUpPlayed() else { return }
        guard WillPlayRepository.cleanUpWillPlay() else { return }
        guard WillPlayRepository.addWillPlays(newMusicFilePaths: filePaths) else { return }
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
