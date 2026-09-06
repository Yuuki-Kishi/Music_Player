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
    @Published var selectedFolderPath: String? = nil
    @Published var folderMusicArray: [Music] = []
    @Published var selectedMusicFilePath: String? = nil
    @Published var folderSortMode: FolderSortMode = .nameAscending
    @Published var folderMusicSortMode: FolderMusicSortMode = .nameAscending
    @Published var isLoading: Bool = false
    @Published var isShowAddPlaylistView: Bool = false
    
    enum FolderSortMode: String {
        case nameAscending, nameDescending, countAscending, countDescending
    }
    
    enum FolderMusicSortMode: String {
        case nameAscending, nameDescending, dateAscending, dateDescending
    }
}
