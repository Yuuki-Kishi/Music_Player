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
        let fileURLs = FileService.getFileURLs()
        var folders: [Folder] = []
        for fileURL in fileURLs {
            let folderName = FileService.getFolderName(fileURL: fileURL)
            if let index = folders.firstIndex(where: { $0.folderName == folderName }) {
                folders[index].musicCount += 1
            } else {
                folders.append(Folder(folderName: folderName, musicCount: 1, folderPath: fileURL.path()))
            }
        }
        FolderDataStore.shared.folderArraySort(mode: FolderDataStore.shared.folderSortMode)
        return folders
    }
    
    static func getFolderMusic(folderName: String) async -> [Music] {
        let fileURLs = FileService.getFileURLs()
        var musics: [Music] = []
        for fileURL in fileURLs {
            let folderNameOfFile = FileService.getFolderName(fileURL: fileURL)
            if folderNameOfFile == folderName {
                let music = await FileService.getFileMetadata(filePath: fileURL.path())
                musics.append(music)
            }
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
