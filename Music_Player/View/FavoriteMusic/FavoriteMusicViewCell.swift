//
//  FavoriteMusicViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/06.
//

import SwiftUI

struct FavoriteMusicViewCell: View {
    @EnvironmentObject private var favoriteMusicDataStore: FavoriteMusicDataStore
    @EnvironmentObject private var playDataStore: PlayDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    private let music: Music
    @State private var isShowAlert = false
    
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
            PlayRepository.setPlayNextMusics(musics: favoriteMusicDataStore.favoriteMusicArray)
        }
        .alert("\(music.musicName)FavoriteMusicViewCell.Alert.title", isPresented: $isShowAlert) {
            alertActions()
        } message: {
            Text("FavoriteMusicViewCell.Alert.message")
        }
    }
    func menuButton() -> some View {
        Menu {
            Button {
                favoriteMusicDataStore.selectedMusicFilePath = music.filePath
                favoriteMusicDataStore.isShowAddPlaylistView = true
            } label: {
                Label("FavoriteMusicViewCell.menuButton.addPlaylist.Label", systemImage: "text.badge.plus")
            }
            Button {
                favoriteMusicDataStore.selectedMusicFilePath = music.filePath
                pathDataStore.musicViewNavigationPath.append(.musicInfo)
            } label: {
                Label("FavoriteMusicViewCell.menuButton.musicInfo.Label", systemImage: "info.circle")
            }
            Divider()
            Button {
                guard PlayFlowRepository.insertFirstPlayNextM3U8(filePath: music.filePath) else { return }
                print("insertSucceeded")
            } label: {
                Label("FavoriteMusicViewCell.menuButton.insertPlayNext.Label", systemImage: "text.line.first.and.arrowtriangle.forward")
            }
            Button {
                guard PlayFlowRepository.addPlayNextM3U8(filePath: music.filePath) else { return }
                print("addSucceeded")
            } label: {
                Label("FavoriteMusicViewCell.menuButton.addPlayNext.Label", systemImage: "text.line.last.and.arrowtriangle.forward")
            }
            Divider()
            Button(role: .destructive) {
                isShowAlert = true
            } label: {
                Label("FavoriteMusicViewCell.menuButton.delete.Label", systemImage: "trash")
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
        guard FavoriteMusicRepository.fileDelete(music: music) else { return }
        print("DeleteSucceeded")
    }
}

#Preview {
    FavoriteMusicViewCell(music: Music())
}
