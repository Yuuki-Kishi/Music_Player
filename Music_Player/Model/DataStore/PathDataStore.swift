//
//  PathDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/03/30.
//

import Foundation

@MainActor
class PathDataStore: ObservableObject {
    static let shared = PathDataStore()
    @Published var musicViewNavigationPath: [MusicViewPath] = []
    @Published var artistViewNavigationPath: [ArtistViewPath] = []
    @Published var albumViewNavigationPath: [AlbumViewPath] = []
    @Published var playlistViewNavigationPath: [PlaylistViewPath] = []
    @Published var folderViewNavigationPath: [FolderViewPath] = []
    @Published var playViewNavigationPath: [PlayViewPath] = []
    
    enum MusicViewPath {
        case addPlaylist, musicInfo, favoriteMusic, selectFavoriteMusic, setting, sleepTImer
    }
    enum ArtistViewPath {
        case artistMusic, addPlaylist, musicInfo
    }
    enum AlbumViewPath {
        case albumMusic, addPlaylist, musicInfo
    }
    enum PlaylistViewPath {
        case playlistMusic, selectMusic, musicInfo
    }
    enum FolderViewPath {
        case folderMusic, addPlaylist, musicInfo
    }
    enum PlayViewPath {
        case addPlaylist, musicInfo, playFlow
    }
}
