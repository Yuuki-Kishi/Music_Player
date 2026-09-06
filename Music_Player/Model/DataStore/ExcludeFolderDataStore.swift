//
//  ExcludeFolderDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/07/28.
//

import Foundation

@MainActor
class ExcludeFolderDataStore: ObservableObject {
    static let shared = ExcludeFolderDataStore()
    @Published var excludeFolderArray: [Folder] = []
    @Published var selectionValue: Set<Folder> = []
    @Published var selectableFolderArray: [Folder] = []
    @Published var excludeFolderSortMode: ExcludeFolderSortMode = .nameAscending
    @Published var isLoading: Bool = true
    
    enum ExcludeFolderSortMode: String {
        case nameAscending, nameDescending, countAscending, countDescending
    }
}
