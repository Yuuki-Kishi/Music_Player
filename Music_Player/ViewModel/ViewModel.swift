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
        get {
            return model.musicArray
        }
        set {
            model.musicArray = newValue
        }
    }
    
    var artistArray: [(artistName: String, musicCount: Int)] {
        get {
            return model.artistArray
        }
        set {
            model.artistArray = newValue
        }
    }
    
    var albumArray: [(albumName: String, musicCount: Int)] {
        get {
            return model.albumArray
        }
        set {
            model.albumArray = newValue
        }
    }
    
    var playListArray: [(playListName: String, musicCount: Int)] {
        get {
            return model.playListArray
        }
        set {
            model.playListArray = newValue
        }
    }
    
    public func directoryCheck() {
        model.directoryCheck()
    }
}
