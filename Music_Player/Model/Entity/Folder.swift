//
//  Folder.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/15.
//

import Foundation

struct Folder: Hashable, Identifiable {
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

@MainActor
extension Array where Element == Folder {
    var selected: Element? {
        guard let selectedFolderPath = FolderDataStore.shared.selectedFolderPath else { return nil }
        return self.first { $0.folderPath == selectedFolderPath }
    }
    mutating func append(noDuplicate item: Element) {
        if let index = self.firstIndex(of: item) {
            self[index] = item
        } else {
            self.append(item)
        }
    }
    mutating func remove(Folder item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

@MainActor
extension Folder {
    var isExclude: Bool {
        ExcludeFolderDataStore.shared.excludeFolderArray.contains { $0.folderPath == self.folderPath }
    }
    var isSelected: Bool {
        ExcludeFolderDataStore.shared.selectionValue.contains { $0.folderPath == self.folderPath }
    }
}
