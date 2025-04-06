//
//  FolderDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/03/30.
//

import Foundation

@MainActor
class FolderDataStore: ObservableObject {
    static let shared = FolderDataStore()
    @Published var folderArray: [Folder] = []
    @Published var selectedFolder: Folder? = nil
    @Published var folderMusicArray: [Music] = []
    @Published var selectedMusic: Music? = nil
    @Published var folderSortMode: FolderSortMode = .nameAscending
    @Published var folderMusicSortMode: FolderMusicSortMode = .nameAscending
    
    enum FolderSortMode {
        case nameAscending, nameDescending, countAscending, countDescending
    }
    
    enum FolderMusicSortMode {
        case nameAscending, nameDescending, dateAscending, dateDescending
    }
    
    func folderArraySort(mode: FolderSortMode) {
        switch mode {
        case .nameAscending:
            folderArray.sort { $0.folderName < $1.folderName }
        case .nameDescending:
            folderArray.sort { $0.folderName > $1.folderName }
        case .countAscending:
            folderArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            folderArray.sort { $0.musicCount > $1.musicCount }
        }
        folderSortMode = mode
    }
    
    func folderMusicArraySort(mode: FolderMusicSortMode) {
        switch mode {
        case .nameAscending:
            folderMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            folderMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            folderMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            folderMusicArray.sort { $0.editedDate > $1.editedDate }
        }
        folderMusicSortMode = mode
    }
}
