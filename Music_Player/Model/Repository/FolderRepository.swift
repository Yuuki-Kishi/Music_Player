//
//  FolderRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/03.
//

import Foundation

@MainActor
class FolderRepository {
    //create
    
    //check
    
    //get
    static func getFolders() async -> [Folder] {
        let filePaths = FileService.getAllFilePaths()
        var folders: [Folder] = []
        for filePath in filePaths {
            let folderPath = FileService.getFolderPath(filePath: filePath)
            if await !ReadFolderRepository.isRead(folderPath: folderPath) { continue }
            guard let folderName = URL(string: folderPath)?.lastPathComponent else { return [] }
            if folderName == "." { continue }
            if let index = folders.firstIndex(where: { $0.folderName == folderName }) {
                folders[index].musicCount += 1
            } else {
                folders.append(Folder(folderName: folderName, musicCount: 1, folderPath: folderPath))
            }
        }
        FolderDataStore.shared.folderArraySort(mode: FolderDataStore.shared.folderSortMode)
        return folders
    }
    
    static func getFolderMusic(folderPath: String) async -> [Music] {
        let filePaths = FileService.getFilePaths(folderPath: folderPath)
        var musics: [Music] = []
        for filePath in filePaths {
            let music = await FileService.getFileMetadata(filePath: folderPath + filePath)
            if await !ReadFolderRepository.isRead(folderPath: music.folderPath) { continue }
            musics.append(music)
        }
        FolderDataStore.shared.folderArraySort(mode: FolderDataStore.shared.folderSortMode)
        return musics
    }
    
    //update
    
    //delete
    static func fileDelete(music: Music) {
        if FileService.fileDelete(filePath: music.filePath) {
            FolderDataStore.shared.folderMusicArray.remove(item: music)
        }
    }
}
