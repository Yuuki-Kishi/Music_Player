//
//  Singleton.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/28.
//

import Foundation

class Singleton {
    static var shared = Singleton()

    var musicArray = [(music: String, artist: String, album: String, belong: String)]()
    var artistArray = [String]()
    var albumArray = [String]()
    var playListName = [String]()
    var listMusicArray = [(music: String, artist: String, album: String)]()
    
    var navigationTitle = ""
    var seekPosition = 0.5
    var playMode = 0
    var isPlay = false
    var showSheet = false
}
