//
//  MusicInfoView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/20.
//

import SwiftUI

struct MusicInfoView: View {
    @EnvironmentObject private var musicDataStore: MusicDataStore
    @EnvironmentObject private var artistDataStore: ArtistDataStore
    @EnvironmentObject private var albumDataStore: AlbumDataStore
    @EnvironmentObject private var playlistDataStore: PlaylistDataStore
    @EnvironmentObject private var folderDataStore: FolderDataStore
    @EnvironmentObject private var favoriteMusicDataStore: FavoriteMusicDataStore
    @EnvironmentObject private var playDataStore: PlayDataStore
    private let music: Music?
    @State private var isShowAlert = false
    
    init(music: Music?) {
        self.music = music
    }
    
    var body: some View {
        List {
            MusicInfoViewCell(music: music, infoType: .musicName, truncationMode: .tail)
            MusicInfoViewCell(music: music, infoType: .artistName, truncationMode: .tail)
            MusicInfoViewCell(music: music, infoType: .albumName, truncationMode: .tail)
            MusicInfoViewCell(music: music, infoType: .musicLength, truncationMode: .tail)
            MusicInfoViewCell(music: music, infoType: .fileSize, truncationMode: .tail)
            MusicInfoViewCell(music: music, infoType: .filePath, truncationMode: .head)
                .contentShape(Rectangle())
                .onTapGesture {
                    UIPasteboard.general.string = music?.filePath ?? ""
                    isShowAlert = true
                }
        }
        .listStyle(.plain)
        .navigationTitle("MusicInfoView.navigationTitle")
        .alert("MusicInfoView.Alert.title", isPresented: $isShowAlert) {
            OKButton()
        } message: {
            Text("MusicInfoView.Alert.message")
        }
    }
}

#Preview {
    MusicInfoView(music: Music())
}
