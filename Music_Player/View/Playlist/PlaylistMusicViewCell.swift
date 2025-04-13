//
//  SwiftUIView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/29.
//
import SwiftUI

struct PlaylistMusicViewCell: View {
    @ObservedObject var playlistDataStore: PlaylistDataStore
    @ObservedObject var playDataStore: PlayDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State var music: Music
    @State private var isShowExcludeAlert = false
    @State private var isShowDeleteAlert = false
    
    var body: some View {
        HStack {
            VStack {
                Text(music.musicName)
                    .lineLimit(1)
                    .font(.system(size: 20.0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(musicNameColor())
                HStack {
                    Text(music.artistName)
                        .lineLimit(1)
                        .font(.system(size: 12.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.gray)
                    Text(music.albumName)
                        .lineLimit(1)
                        .font(.system(size: 12.5))
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundStyle(Color.gray)
                }
            }
            Text(secToMin(second:music.musicLength))
                .foregroundStyle(Color.gray)
            menuButton()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            tapped()
        }
        .alert("本当に除外しますか？", isPresented: $isShowExcludeAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                excludeMusic()
            }, label: {
                Text("除外")
            })
        }, message: {
            Text("再度プレイリストに入れたい場合は、再度追加してください。")
        })
        .alert("本当に削除しますか？", isPresented: $isShowDeleteAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                deleteMusicFile()
            }, label: {
                Text("削除")
            })
        }, message: {
            Text("この操作は取り消すことができません。この項目はゴミ箱に移動されます。")
        })
    }
    func musicNameColor() -> Color {
        if music == playDataStore.playingMusic {
            return .accent
        } else {
            return .primary
        }
    }
    func secToMin(second: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        if second < 3600 { dateFormatter.allowedUnits = [.minute, .second] }
        else { dateFormatter.allowedUnits = [.hour, .minute, .second] }
        dateFormatter.zeroFormattingBehavior = .pad
        return dateFormatter.string(from: second)!
    }
    func tapped() {
        if !FileService.isExistFile(filePath: music.filePath) {
            Task {
                guard let playlistFilePath = playlistDataStore.selectedPlaylist?.filePath else { return }
                guard PlaylistRepository.removePlaylistMusic(playlistFilePath: playlistFilePath, musicFilePath: music.filePath) else { return }
                playlistDataStore.playlistMusicArray = await PlaylistRepository.getPlaylistMusic(filePath: playlistFilePath)
            }
        }
        playDataStore.musicChoosed(music: music, playGroup: .playlist)
        playDataStore.setNextMusics(musicFilePaths: playlistDataStore.playlistMusicArray.map { $0.filePath })
    }
    func menuButton() -> some View {
        Menu {
            Button(action: {
                playlistDataStore.selectedMusic = music
                pathDataStore.playlistViewNavigationPath.append(.musicInfo)
            }, label: {
                Label("曲の情報", systemImage: "info.circle")
            })
            Divider()
            Button(action: {
                if WillPlayRepository.insertWillPlay(newMusicFilePath: music.filePath, at: 0) {
                    print("succeeded")
                }
            }, label: {
                Label("次に再生", systemImage: "text.line.first.and.arrowtriangle.forward")
            })
            Divider()
            Button(role: .destructive, action: {
                isShowExcludeAlert = true
            }, label: {
                Label("プレイリストから除外", systemImage: "minus.circle")
            })
            Button(role: .destructive, action: {
                isShowDeleteAlert = true
            }, label: {
                Label("ファイルを削除", systemImage: "trash")
            })
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.primary)
                .frame(width: 40, height: 40)
        }
    }
    func excludeMusic() {
        Task {
            guard let playlistFilePath = playlistDataStore.selectedPlaylist?.filePath else { return }
            guard PlaylistRepository.removePlaylistMusic(playlistFilePath: playlistFilePath, musicFilePath: music.filePath) else { return }
            playlistDataStore.playlistMusicArray = await PlaylistRepository.getPlaylistMusic(filePath: playlistFilePath)
        }
    }
    func deleteMusicFile() {
        Task {
            playDataStore.stop()
            playDataStore.playingMusic = nil
            guard FileService.fileDelete(filePath: music.filePath) else { return }
            print("DeleteSucceeded")
            guard let filePath = playlistDataStore.selectedPlaylist?.filePath else { return }
            playlistDataStore.playlistMusicArray = await PlaylistRepository.getPlaylistMusic(filePath: filePath)
            playlistDataStore.loadMusicSort()
        }
    }
}

#Preview {
    PlaylistMusicViewCell(playlistDataStore: PlaylistDataStore.shared, playDataStore: PlayDataStore.shared, pathDataStore: PathDataStore.shared, music: Music())
}
