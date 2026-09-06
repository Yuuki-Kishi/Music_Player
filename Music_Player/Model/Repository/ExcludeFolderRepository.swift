//
//  ExcludeFolderRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/15.
//

import Foundation

@MainActor
class ExcludeFolderRepository {
    static let excludeFolderDataStore: ExcludeFolderDataStore = .shared
    static let excludeFolderFilePath: String = "System/ExcludeFolder.m3u8"
    
    //create
    static func createExcludeFolder() -> Bool {
        let content = "#EXTM3U\n" + "#ExcludeFolder"
        return FileService.createFile(filePath: excludeFolderFilePath, content: content)
    }
    
    //check
    static func isExistExcludeFolder() -> Bool {
        FileService.isExist(path: excludeFolderFilePath)
    }
    
    static func isExclude(filePath: String) -> Bool {
        let folderPath = URL(filePath: filePath).deletingLastPathComponent().planePath
        return getExcludeFolderPaths().contains(folderPath)
    }
    
    //get
    static func getExcludeFolderPaths() -> [String] {
        M3U8Service.getM3U8Components(filePath: excludeFolderFilePath)
    }
    
    static func getExcludeFolders() -> [Folder] {
        let folderPaths = M3U8Service.getM3U8Components(filePath: excludeFolderFilePath)
        var folders: [Folder] = []
        for folderPath in folderPaths {
            let folderName = URL(filePath: folderPath).lastPathComponent
            if let index = folders.firstIndex(where: { $0.folderName == folderName }) {
                folders[index].musicCount += 1
            } else {
                folders.append(Folder(folderName: folderName, musicCount: 1, folderPath: folderPath))
            }
        }
        return folders
    }
    
    static func getSelectableFolders() -> [Folder] {
        let filePaths = FileService.getAllFilePaths()
        var folders: [Folder] = []
        for filePath in filePaths {
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
    
    //update
    static func updateExcludeFolder() -> Bool {
        let contents = excludeFolderDataStore.excludeFolderArray.map { $0.folderPath }
        return M3U8Service.updateM3U8(filePath: excludeFolderFilePath, contents: contents)
    }
    
    static func sortAndUpdateExcludeFolderSortMode(sortMode: ExcludeFolderDataStore.ExcludeFolderSortMode) {
        switch sortMode {
        case .nameAscending:
            excludeFolderDataStore.excludeFolderArray.sort { $0.folderName < $1.folderName }
        case .nameDescending:
            excludeFolderDataStore.excludeFolderArray.sort { $0.folderName > $1.folderName }
        case .countAscending:
            excludeFolderDataStore.excludeFolderArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            excludeFolderDataStore.excludeFolderArray.sort { $0.musicCount > $1.musicCount }
        }
        UserDefaultsRepository.save(key: "excludeFolderSortMode", value: sortMode.rawValue)
    }
    
    static func sortFolderArray() {
        guard let sortModeString = UserDefaultsRepository.load(key: "excludeFolderSortMode", as: String.self) else { return }
        guard let sortMode = ExcludeFolderDataStore.ExcludeFolderSortMode(rawValue: sortModeString) else { return }
        switch sortMode {
        case .nameAscending:
            excludeFolderDataStore.excludeFolderArray.sort { $0.folderName < $1.folderName }
        case .nameDescending:
            excludeFolderDataStore.excludeFolderArray.sort { $0.folderName > $1.folderName }
        case .countAscending:
            excludeFolderDataStore.excludeFolderArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            excludeFolderDataStore.excludeFolderArray.sort { $0.musicCount > $1.musicCount }
        }
    }
    
    //delete
    static func removeExcludeFolder(folderPath: String) -> Bool {
        var excludeFolderPaths = getExcludeFolderPaths()
        excludeFolderPaths.remove(item: folderPath)
        return M3U8Service.updateM3U8(filePath: excludeFolderFilePath, contents: excludeFolderPaths)
    }
}
