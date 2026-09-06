//
//  MusicNameView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/08/25.
//

import SwiftUI

struct MusicNameView: View {
    @EnvironmentObject private var playDataStore: PlayDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    
    var body: some View {
        HStack {
            VStack {
                Text(musicNameString())
                    .lineLimit(1)
                    .font(.system(size: 25).bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(artistNameString())
                    .lineLimit(1)
                    .font(.system(size: 20))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 50)
            Button {
                favoriteToggleAction()
            } label: {
                Image(systemName: favoriteButtonIconName())
                    .font(.system(size: 15, weight: .semibold))
                    .frame(width: 30, height: 30)
                    .background(Color(UIColor.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            musicMenu()
                .font(.system(size: 20, weight: .semibold))
                .frame(width: 30, height: 30)
                .background(Color(UIColor.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
        .padding(.horizontal)
    }
    func musicNameString() -> LocalizedStringKey {
        guard let musicName = playDataStore.playingMusic?.musicName else { return "MusicNameView.musicNameText.playingMusicIsNil.Text" }
        return LocalizedStringKey(musicName)
    }
    func artistNameString() -> String {
        guard let artistName = playDataStore.playingMusic?.artistName else { return "" }
        return artistName
    }
    func favoriteToggleAction() {
        guard let filePath = playDataStore.playingMusic?.filePath else { return }
        guard FavoriteMusicRepository.toggleFavoriteMusic(filePath: filePath) else { return }
        print("toggleSucceeded")
    }
    func favoriteButtonIconName() -> String {
        guard let filePath = playDataStore.playingMusic?.filePath else { return "star"}
        return FavoriteMusicRepository.isFavoriteMusic(filePath: filePath) ? "star.fill" : "star"
    }
    func musicMenu() -> some View {
        Menu {
            Button {
                playDataStore.isShowAddPlaylistView = true
            } label: {
                Label("MusicNameView.menuButton.addPlaylist.Label", systemImage: "text.badge.plus")
            }
            Button {
                pathDataStore.playViewNavigationPath.append(.musicInfo)
            } label: {
                Label("MusicNameView.menuButton.musicInfo.Label", systemImage: "info.circle")
            }
            Divider()
            Button {
                guard let filePath = playDataStore.playingMusic?.filePath else { return }
                guard PlayFlowRepository.insertFirstPlayNextM3U8(filePath: filePath) else { return }
                print("insertSucceeded")
            } label: {
                Label("MusicNameView.menuButton.insertPlayNext.Label", systemImage: "text.line.first.and.arrowtriangle.forward")
            }
            Button {
                guard let filePath = playDataStore.playingMusic?.filePath else { return }
                guard PlayFlowRepository.addPlayNextM3U8(filePath: filePath) else { return }
                print("addSucceeded")
            } label: {
                Label("MusicNameView.menuButton.addPlayNext.Label", systemImage: "text.line.last.and.arrowtriangle.forward")
            }
        } label: {
            Image(systemName: "ellipsis")
                .frame(width: 40, height: 40)
        }
        .menuOrder(.fixed)
    }
}

#Preview {
    MusicNameView()
}
