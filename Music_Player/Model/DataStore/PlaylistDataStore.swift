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
    @Published var selectedPlaylist: Playlist? = nil
    @Published var playlistMusicArray: [Music] = []
    @Published var selectedMusic: Music? = nil
    @Published var playlistSortMode: PlaylistSortMode = .nameAscending
    @Published var playlistMusicSortMode: PlaylistMusicSortMode = .nameAscending
    
    enum PlaylistSortMode {
        case nameAscending, nameDescending, countAscending, countDescending
    }
    
    enum PlaylistMusicSortMode {
        case nameAscending, nameDescending, dateAscending, dateDescending
    }
    
    func playlistArraySort(mode: PlaylistSortMode) {
        switch mode {
        case .nameAscending:
            playlistArray.sort { $0.playlistName < $1.playlistName }
        case .nameDescending:
            playlistArray.sort { $0.playlistName > $1.playlistName }
        case .countAscending:
            playlistArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            playlistArray.sort { $0.musicCount > $1.musicCount }
        }
        playlistSortMode = mode
    }
    
    func playlistMusicArraySort(mode: PlaylistMusicSortMode) {
        switch mode {
        case .nameAscending:
            playlistMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            playlistMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            playlistMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            playlistMusicArray.sort { $0.editedDate > $1.editedDate }
        }
        playlistMusicSortMode = mode
    }
}
