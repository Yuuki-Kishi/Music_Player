//
//  PlaylistData.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/03/29.
//

import Foundation

@MainActor
class PlaylistDataStore: ObservableObject {
    static let shared = PlaylistDataStore()
    @Published var playlistArray: [Playlist] = []
    @Published var selectedPlaylistFilePath: String? = nil
    @Published var playlistMusicArray: [Music] = []
    @Published var selectedMusicFilePath: String? = nil
    @Published var playlistSortMode: PlaylistSortMode = .nameAscending
    @Published var playlistMusicSortMode: PlaylistMusicSortMode = .nameAscending
    @Published var isLoading: Bool = false
    @Published var selectionValue: Set<Music> = []
    @Published var selectableMusicArray: [Music] = []
    
    enum PlaylistSortMode: String {
        case nameAscending, nameDescending, countAscending, countDescending
    }
    
    enum PlaylistMusicSortMode: String {
        case nameAscending, nameDescending, dateAscending, dateDescending
    }
}
