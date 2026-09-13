//
//  ArtistMusicViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import SwiftUI

struct ArtistMusicViewCell: View {
    @EnvironmentObject private var artistDataStore: ArtistDataStore
    @EnvironmentObject private var playDataStore: PlayDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    private let music: Music
    @State private var isShowAlert: Bool = false
    
    init(music: Music) {
        self.music = music
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(music.musicName)
                    .lineLimit(1)
                    .font(.system(size: 20.0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(music.filePath == playDataStore.playingMusic?.filePath ? .accent : .primary)
                HStack {
                    Text(music.artistAndAlbumName)
                        .lineLimit(1)
                        .font(.system(size: 12.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.secondary)
                }
            }
            Text(music.musicLength.formattedTime)
                .foregroundStyle(.secondary)
            menuButton()
                .frame(width: 40, height: 40)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            PlayRepository.musicSelected(music: music)
            PlayRepository.setPlayNextMusics(musics: artistDataStore.artistMusicArray)
        }
        .alert("\(music.musicName)ArtistMusicViewCell.Alert.title", isPresented: $isShowAlert) {
            alertActions()
        } message: {
            Text("ArtistMusicViewCell.Alert.message")
        }
    }
    func menuButton() -> some View {
        Menu {
            Button {
                artistDataStore.selectedMusicFilePath = music.filePath
                artistDataStore.isShowAddPlaylistView = true
            } label: {
                Label("ArtistMusicViewCell.menuButton.addPlaylist.Label", systemImage: "text.badge.plus")
            }
            Button {
                artistDataStore.selectedMusicFilePath = music.filePath
                pathDataStore.artistViewNavigationPath.append(.musicInfo)
            } label: {
                Label("ArtistMusicViewCell.menuButton.musicInfo.Label", systemImage: "info.circle")
            }
            Divider()
            Button {
                guard PlayFlowRepository.insertFirstPlayNextM3U8(filePath: music.filePath) else { return }
                print("insertSucceeded")
            } label: {
                Label("ArtistMusicViewCell.menuButton.insertPlayNext.Label", systemImage: "text.line.first.and.arrowtriangle.forward")
            }
            Button {
                guard PlayFlowRepository.addPlayNextM3U8(filePath: music.filePath) else { return }
                print("addSucceeded")
            } label: {
                Label("ArtistMusicViewCell.menuButton.addPlayNext.Label", systemImage: "text.line.last.and.arrowtriangle.forward")
            }
            Divider()
            Button(role: .destructive) {
                isShowAlert = true
            } label: {
                Label("ArtistMusicViewCell.menuButton.delete.Label", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.primary)
        }
    }
    @ViewBuilder
    func alertActions() -> some View {
        CancelButton()
        DeleteButton {
            deleteMusicFile()
        }
    }
    func deleteMusicFile() {
        if music.isPlayingMusic {
            PlayRepository.stop()
            playDataStore.playingMusic = nil
        }
        guard ArtistRepository.fileDelete(music: music) else { return }
        print("DeleteSucceeded")
    }
}

#Preview {
    ArtistMusicViewCell(music: Music())
}
