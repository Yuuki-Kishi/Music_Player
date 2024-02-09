//
//  ViewModel.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/06.
//

import Foundation

@MainActor
class ViewModel: ObservableObject {
    @Published var model: FileService
    
    init(model: FileService) {
        self.model = model
    }
    
    var musicArray: [(musicName: String, artistName: String, albumName: String, belongDirectory: String)] {
        get { return model.musicArray }
        set { model.musicArray = newValue }
    }
    
    var artistArray: [(artistName: String, musicCount: Int)] {
        get { return model.artistArray }
        set { model.artistArray = newValue }
    }
    
    var albumArray: [(albumName: String, musicCount: Int)] {
        get { return model.albumArray }
        set { model.albumArray = newValue }
    }
    
    var playListArray: [(playListName: String, musicCount: Int)] {
        get { return model.playListArray }
        set { model.playListArray = newValue }
    }
    
    var listMusicArray: [(musicName: String, artistName: String, albumName: String, belongDirectory: String)] {
        get { return model.listMusicArray }
        set { model.listMusicArray = newValue }
    }
    
    var seekPosition: Double {
        get { return model.seekPosition }
        set { model.seekPosition = newValue }
    }
    
    var isPlay: Bool {
        get { return model.isPlay }
        set { model.isPlay = newValue }
    }
    
    var showSheet: Bool {
        get { return model.showSheet }
        set { model.showSheet = newValue }
    }
    
    public func directoryCheck() {
        model.directoryCheck()
    }
    
    public func collectMusicOfArtist(artist: String) {
        model.collectMusicOfArtist(artist: artist)
    }
    
    public func collectMusicOfAlbum(album: String) {
        model.collectMusicOfAlbum(album: album)
    }
    
    public func collectMusicOfPlayList(playList: String) {
        model.collectMusicOfPlayList(playList: playList)
    }
}
