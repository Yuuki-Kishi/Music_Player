//
//  FolderRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/03.
//

import Foundation

@MainActor
class FolderRepository {
    static let folderDataStore: FolderDataStore = .shared
    
    //create
    
    //check
    
    //get
    static func getFolders() async -> [Folder] {
        let filePaths = FileService.getAllFilePaths()
        var folders: [Folder] = []
        for filePath in filePaths {
            guard !ExcludeFolderRepository.isExclude(filePath: filePath) else { continue }
            let folderPath = URL(filePath: filePath).deletingLastPathComponent().planePath
            let folderName = URL(filePath: folderPath).lastPathComponent
            if let index = folders.firstIndex(where: { $0.folderName == folderName }) {
                folders[index].musicCount += 1
            } else {
                folders.append(Folder(folderName: folderName, musicCount: 1, folderPath: folderPath))
            }
        }
        return folders
    }
    
    static func getFolderMusic() async -> [Music] {
        guard let folderPath = folderDataStore.folderArray.selected?.folderPath else { return [] }
        let filePaths = FileService.getAllFilePaths()
        var musics: [Music] = []
        for filePath in filePaths {
            guard !ExcludeFolderRepository.isExclude(filePath: filePath) else { continue }
            guard let music = await FileService.getFileMetadata(filePath: filePath) else { continue }
            let musicFolderPath = URL(filePath: filePath).deletingLastPathComponent().planePath
//            let musicFolderName = URL(filePath: musicFolderPath).lastPathComponent
            guard musicFolderPath == folderPath else { continue }
            musics.append(music)
        }
        return musics
    }
    
    //update
    static func sortAndUpdateFolderSortMode(sortMode: FolderDataStore.FolderSortMode) {
        switch sortMode {
        case .nameAscending:
            folderDataStore.folderArray.sort { $0.folderName < $1.folderName }
        case .nameDescending:
            folderDataStore.folderArray.sort { $0.folderName > $1.folderName }
        case .countAscending:
            folderDataStore.folderArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            folderDataStore.folderArray.sort { $0.musicCount > $1.musicCount }
        }
        UserDefaultsRepository.save(key: "FolderSortMode", value: sortMode.rawValue)
    }
    
    static func sortFolderArray() {
        guard let sortModeString = UserDefaultsRepository.load(key: "FolderSortMode", as: String.self) else { return }
        guard let sortMode = FolderDataStore.FolderSortMode(rawValue: sortModeString) else { return }
        switch sortMode {
        case .nameAscending:
            folderDataStore.folderArray.sort { $0.folderName < $1.folderName }
        case .nameDescending:
            folderDataStore.folderArray.sort { $0.folderName > $1.folderName }
        case .countAscending:
            folderDataStore.folderArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            folderDataStore.folderArray.sort { $0.musicCount > $1.musicCount }
        }
    }
    
    static func sortAndUpdateFolderMusicSortMode(sortMode: FolderDataStore.FolderMusicSortMode) {
        switch sortMode {
        case .nameAscending:
            folderDataStore.folderMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            folderDataStore.folderMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            folderDataStore.folderMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            folderDataStore.folderMusicArray.sort { $0.editedDate > $1.editedDate }
        }
        UserDefaultsRepository.save(key: "FolderMusicSortMode", value: sortMode.rawValue)
    }
    
    static func sortFolderMusicArray() {
        guard let sortModeString = UserDefaultsRepository.load(key: "FolderMusicSortMode", as: String.self) else { return }
        guard let sortMode = FolderDataStore.FolderMusicSortMode(rawValue: sortModeString) else { return }
        switch sortMode {
        case .nameAscending:
            folderDataStore.folderMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            folderDataStore.folderMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            folderDataStore.folderMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            folderDataStore.folderMusicArray.sort { $0.editedDate > $1.editedDate }
        }
    }
    
    //delete
    static func fileDelete(music: Music) -> Bool {
        guard FileService.fileDelete(filePath: music.filePath) else { return false }
        folderDataStore.folderMusicArray.remove(Music: music)
        return true
    }
}
