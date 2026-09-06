//
//  SwiftUIView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/29.
//
import SwiftUI

struct PlaylistMusicViewCell: View {
    @EnvironmentObject private var playlistDataStore: PlaylistDataStore
    @EnvironmentObject private var playDataStore: PlayDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    private let music: Music
    @State private var isShowExcludeAlert: Bool = false
    @State private var isShowDeleteAlert: Bool = false
    
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
            PlayRepository.setPlayNextMusics(musics: playlistDataStore.playlistMusicArray)
        }
        .alert("PlaylistMusicViewCell.excludeAlert.title", isPresented: $isShowExcludeAlert) {
            excludeAlertActions()
        } message: {
            Text("PlaylistMusicViewCell.excludeAlert.message")
        }
        .alert("\(music.musicName)PlaylistMusicViewCell.deleteAlert.title", isPresented: $isShowDeleteAlert) {
            deleteAlertActions()
        } message: {
            Text("PlaylistMusicViewCell.deleteAlert.message")
        }
    }
    func menuButton() -> some View {
        Menu {
            Button {
                playlistDataStore.selectedMusicFilePath = music.filePath
                pathDataStore.playlistViewNavigationPath.append(.musicInfo)
            } label: {
                Label("PlaylistMusicViewCell.menuButton.musicInfo.Label", systemImage: "info.circle")
            }
            Divider()
            Button {
                guard PlayFlowRepository.insertFirstPlayNextM3U8(filePath: music.filePath) else { return }
                print("insertSucceeded")
            } label: {
                Label("PlaylistMusicViewCell.menuButton.insertPlayNext.Label", systemImage: "text.line.first.and.arrowtriangle.forward")
            }
            Button {
                guard PlayFlowRepository.addPlayNextM3U8(filePath: music.filePath) else { return }
                print("addSucceeded")
            } label: {
                Label("PlaylistMusicViewCell.menuButton.addPlayNext.Label", systemImage: "text.line.last.and.arrowtriangle.forward")
            }
            Divider()
            Button(role: .destructive) {
                isShowExcludeAlert = true
            } label: {
                Label("PlaylistMusicViewCell.menuButton.exclude.Label", systemImage: "minus.circle")
            }
            Button(role: .destructive) {
                isShowDeleteAlert = true
            } label: {
                Label("PlaylistMusicViewCell.menuButton.delete.Label", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.primary)
                .frame(width: 40, height: 40)
        }
    }
    @ViewBuilder
    func excludeAlertActions() -> some View {
        CancelButton()
        Button(role: .destructive) {
            guard let playlistFilePath = playlistDataStore.playlistArray.selected?.filePath else { return }
            guard PlaylistRepository.removePlaylistMusic(playlistFilePath: playlistFilePath, musicFilePath: music.filePath) else { return }
            print("removeSucceeded")
            playlistDataStore.playlistMusicArray.remove(Music: music)
        } label: {
            Text("PlaylistMusicViewCell.excludeAlertActions.Button.Text")
        }
    }
    @ViewBuilder
    func deleteAlertActions() -> some View {
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
        guard PlaylistRepository.fileDelete(music: music) else { return }
        print("DeleteSucceeded")
    }
}

#Preview {
    PlaylistMusicViewCell(music: Music())
}
