//
//  MusicViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/06.
//

import SwiftUI

struct MusicViewCell: View {
    @EnvironmentObject private var musicDataStore: MusicDataStore
    @EnvironmentObject private var playDataStore: PlayDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    private var music: Music
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
            PlayRepository.setPlayNextMusics(musics: musicDataStore.musicArray)
        }
        .alert("\(music.musicName)MusicViewCell.Alert.title", isPresented: $isShowAlert) {
            alertActions()
        } message: {
            Text("MusicViewCell.Alert.message")
        }
    }
    func menuButton() -> some View {
        Menu {
            Button {
                musicDataStore.selectedMusicFilePath = music.filePath
                musicDataStore.isShowAddPlaylistView = true
            } label: {
                Label("MusicViewCell.menuButton.addPlaylist.Label", systemImage: "text.badge.plus")
            }
            Button(action: {
                musicDataStore.selectedMusicFilePath = music.filePath
                pathDataStore.musicViewNavigationPath.append(.musicInfo)
            }, label: {
                Label("MusicViewCell.menuButton.musicInfo.Label", systemImage: "info.circle")
            })
            Divider()
            Button {
                guard PlayFlowRepository.insertFirstPlayNextM3U8(filePath: music.filePath) else { return }
                print("insertSucceeded")
            } label: {
                Label("MusicViewCell.menuButton.insertPlayNext.Label", systemImage: "text.line.first.and.arrowtriangle.forward")
            }
            Button {
                guard PlayFlowRepository.addPlayNextM3U8(filePath: music.filePath) else { return }
                print("addSucceeded")
            } label: {
                Label("MusicViewCell.menuButton.addPlayNext.Label", systemImage: "text.line.last.and.arrowtriangle.forward")
            }
            Divider()
            Button(role: .destructive, action: {
                isShowAlert = true
            }, label: {
                Label("MusicViewCell.menuButton.delete.Label", systemImage: "trash")
            })
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
        guard MusicRepository.fileDelete(music: music) else { return }
        print("DeleteSucceeded")
    }
}

#Preview {
    MusicViewCell(music: Music())
}
