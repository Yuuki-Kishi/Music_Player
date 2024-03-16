//
//  Folder.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/15.
//

import Foundation

class Folder: Identifiable {
    var id = UUID()
    var folderName: String
    var musicCount: Int
    var folderPath: String
    
    init(folderName: String, musicCount: Int, folderPath: String) {
        self.folderName = folderName
        self.musicCount = musicCount
        self.folderPath = folderPath
    }
}
