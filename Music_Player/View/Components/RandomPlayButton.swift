//
//  RandomPlayButton.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/07/28.
//

import SwiftUI

struct RandomPlayButton: View {
    @EnvironmentObject private var musicDataStore: MusicDataStore
    @EnvironmentObject private var artistDataStore: ArtistDataStore
    @EnvironmentObject private var albumDataStore: AlbumDataStore
    @EnvironmentObject private var playlistDataStore: PlaylistDataStore
    @EnvironmentObject private var folderDataStore: FolderDataStore
    @EnvironmentObject private var favoriteMusicDataStore: FavoriteMusicDataStore
    private let dataStore: DataStoreEnum
    
    enum DataStoreEnum {
        case music, artist, album, playlist, folder, favorite
    }
    
    init(dataStore: DataStoreEnum) {
        self.dataStore = dataStore
    }
    
    var body: some View {
        Button{
            randomPlay()
        } label: {
            HStack {
                Image(systemName: "play.circle")
                    .foregroundStyle(.accent)
                Text("\(musicCountString())RandomPlayButton.label.Text")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text(allMusicLengthString())
                    .foregroundStyle(.secondary)
                    .frame(alignment: .trailing)
            }
            .padding(.horizontal)
        }
        .foregroundStyle(.primary)
    }
    func randomPlay() {
        switch dataStore {
        case .music:
            PlayRepository.randomPlay(musics: musicDataStore.musicArray)
        case .artist:
            PlayRepository.randomPlay(musics: artistDataStore.artistMusicArray)
        case .album:
            PlayRepository.randomPlay(musics: albumDataStore.albumMusicArray)
        case .playlist:
            PlayRepository.randomPlay(musics: playlistDataStore.playlistMusicArray)
        case .folder:
            PlayRepository.randomPlay(musics: folderDataStore.folderMusicArray)
            PlayFlowRepository.setPlayNextMusics(musics: folderDataStore.folderMusicArray)
        case .favorite:
            PlayRepository.randomPlay(musics: favoriteMusicDataStore.favoriteMusicArray)
        }
    }
    func musicCountString() -> String {
        switch dataStore {
        case .music:
            return String(musicDataStore.musicArray.count)
        case .artist:
            return String(artistDataStore.artistMusicArray.count)
        case .album:
            return String(albumDataStore.albumMusicArray.count)
        case .playlist:
            return String(playlistDataStore.playlistMusicArray.count)
        case .folder:
            return String(folderDataStore.folderMusicArray.count)
        case .favorite:
            return String(favoriteMusicDataStore.favoriteMusicArray.count)
        }
    }
    func allMusicLengthString() -> String {
        switch dataStore {
        case .music:
            return musicDataStore.musicArray.reduce(0) { $0 + $1.musicLength }.formattedTime
        case .artist:
            return artistDataStore.artistMusicArray.reduce(0) { $0 + $1.musicLength }.formattedTime
        case .album:
            return albumDataStore.albumMusicArray.reduce(0) { $0 + $1.musicLength }.formattedTime
        case .playlist:
            return playlistDataStore.playlistMusicArray.reduce(0) { $0 + $1.musicLength }.formattedTime
        case .folder:
            return folderDataStore.folderMusicArray.reduce(0) { $0 + $1.musicLength }.formattedTime
        case .favorite:
            return favoriteMusicDataStore.favoriteMusicArray.reduce(0) { $0 + $1.musicLength }.formattedTime
        }
    }
}

#Preview {
    RandomPlayButton(dataStore: .music)
}
