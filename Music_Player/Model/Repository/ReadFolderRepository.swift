//
//  DisplayFolderRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/15.
//

import Foundation
import SwiftData

class ReadFolderRepository {
    static let actor = {
        return PersistanceActor(modelContainer: Persistance.sharedModelContainer)
    }()
    
    //create
    static func createReadFolders(folders: [Folder]) async {
        for folder in folders {
            let ReadFolder = ReadFolder(folderPath: folder.folderPath, isRead: true)
            await actor.insert(ReadFolder)
        }
    }
    
    static func createNotReadFolders(folders: [Folder]) async {
        for folder in folders {
            let ReadFolder = ReadFolder(folderPath: folder.folderPath, isRead: false)
            await actor.insert(ReadFolder)
        }
    }
    
    //check
    static func isRead(folderPath: String) async -> Bool {
        if folderPath == "./" { return true }
        let readFolders = await getReadFolders()
        let isRead = readFolders.first(where: { $0.folderPath == folderPath })?.isRead ?? false
        let isContain = readFolders.contains(where: { $0.folderPath == folderPath })
        return isRead || !isContain ? true : false
    }
    
    //get
    static func getReadFolders() async -> [ReadFolder] {
        let predicate = #Predicate<ReadFolder> { readFolder in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        var readFolders = await actor.get(descriptor) ?? []
        for readFolder in readFolders {
            if !FileService.isExistDirectory(folderPath: readFolder.folderPath) {
                await deleteReadFolder(readFolder: readFolder)
                guard let index = readFolders.firstIndex(where: { $0.folderPath == readFolder.folderPath }) else { continue }
                readFolders.remove(at: index)
            }
        }
        return readFolders
    }
    
    static func getAllFolderPaths() -> [String] {
        let filePaths = FileService.getAllFilePaths()
        var folderPaths: [String] = []
        for filePath in filePaths {
            let folderPath = FileService.getFolderPath(filePath: filePath)
            if folderPath == "./" { continue }
            folderPaths.append(folderPath)
        }
        return folderPaths
    }
    
    static func getSelectableFolders() -> [Folder] {
        let folderPaths = getAllFolderPaths()
        var folders: [Folder] = []
        for folderPath in folderPaths {
            let folderName = URL(fileURLWithPath: folderPath).lastPathComponent
            if let index = folders.firstIndex(where: { $0.folderName == folderName }) {
                folders[index].musicCount += 1
            } else {
                let folder = Folder(folderName: folderName, musicCount: 1, folderPath: folderPath)
                folders.append(folder)
            }
        }
        return folders
    }
    
    //delete
    static func deleteReadFolder(readFolder: ReadFolder) async {
        await actor.delete(readFolder)
    }
    
    static func deleteAll() async {
        for readFolder in await getReadFolders() {
            await actor.delete(readFolder)
        }
    }
}
