//
//  Folder.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/15.
//

import Foundation

struct Folder: Hashable, Identifiable, Equatable {
    static func == (lhs: Folder, rhs: Folder) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = UUID()
    var folderName: String
    var musicCount: Int
    var folderPath: String
    
    init(folderName: String, musicCount: Int, folderPath: String) {
        self.folderName = folderName
        self.musicCount = musicCount
        self.folderPath = folderPath
    }
    
    init () {
        self.folderName = "unknownFolder"
        self.musicCount = 0
        self.folderPath = "unknownFolderPath"
    }
}
