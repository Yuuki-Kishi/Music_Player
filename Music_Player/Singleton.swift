//
//  Singleton.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/28.
//

import Foundation

class Singleton {
    static var shared = Singleton()
    var musicArray = [(music: String, artist: String, album: String)]()
    var artistArray = [(artistName: String, musicCount: Int)]()
    var albumArray = [(albumName: String, musicCount: Int)]()
    var playListName = [(playListName: String, musicCount: Int)]()
    var listMusicArray = [(music: String, artist: String, album: String)]()
    
    var progressValue = 10.0
}
