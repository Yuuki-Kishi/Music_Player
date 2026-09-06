//
//  AlbumMusicViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import SwiftUI

struct AlbumMusicViewCell: View {
    @EnvironmentObject private var albumDataStore: AlbumDataStore
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
                Text(music.artistName + " - " + music.albumName)
                    .lineLimit(1)
                    .font(.system(size: 12.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.secondary)
            }
            Text(music.musicLength.formattedTime)
                .foregroundStyle(.secondary)
            menuButton()
                .frame(width: 40, height: 40)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            PlayRepository.musicSelected(music: music)
            PlayRepository.setPlayNextMusics(musics: albumDataStore.albumMusicArray)
        }
        .alert("\(music.musicName)AlbumMusicViewCell.Alert.title", isPresented: $isShowAlert) {
            alertActions()
        } message: {
            Text("AlbumMusicViewCell.Alert.message")
        }
    }
    func menuButton() -> some View {
        Menu {
            Button {
                albumDataStore.selectedMusicFilePath = music.filePath
                albumDataStore.isShowAddPlaylistView = true
            } label: {
                Label("AlbumMusicViewCell.menuButton.addPlaylist.Label", systemImage: "text.badge.plus")
            }
            Button {
                albumDataStore.selectedMusicFilePath = music.filePath
                pathDataStore.albumViewNavigationPath.append(.musicInfo)
            } label: {
                Label("AlbumMusicViewCell.menuButton.musicInfo.Label", systemImage: "info.circle")
            }
            Divider()
            Button {
                guard PlayFlowRepository.insertFirstPlayNextM3U8(filePath: music.filePath) else { return }
                print("insertSucceeded")
            } label: {
                Label("AlbumMusicViewCell.menuButton.insertPlayNext.Label", systemImage: "text.line.first.and.arrowtriangle.forward")
            }
            Button {
                guard PlayFlowRepository.addPlayNextM3U8(filePath: music.filePath) else { return }
                print("addSucceeded")
            } label: {
                Label("AlbumMusicViewCell.menuButton.addPlayNext.Label", systemImage: "text.line.last.and.arrowtriangle.forward")
            }
            Divider()
            Button(role: .destructive) {
                isShowAlert = true
            } label: {
                Label("AlbumMusicViewCell.menuButton.delete.Label", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.primary)
                .frame(width: 40, height: 40)
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
        guard AlbumRepository.fileDelete(music: music) else { return }
        print("DeleteSucceeded")
    }
}

#Preview {
    AlbumMusicViewCell(music: Music())
}
