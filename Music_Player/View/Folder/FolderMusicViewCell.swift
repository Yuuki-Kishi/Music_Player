//
//  FolderMusicViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/02.
//

import SwiftUI

struct FolderMusicViewCell: View {
    @ObservedObject var folderDataStore: FolderDataStore
    @ObservedObject var playDataStore: PlayDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State var music: Music
    @State private var isShowAlert = false
    
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
                        .foregroundStyle(.secondary)
                    Text(music.albumName)
                        .lineLimit(1)
                        .font(.system(size: 12.5))
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundStyle(.secondary)
                }
            }
            Text(secToMin(second:music.musicLength))
                .foregroundStyle(.secondary)
            menuButton()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            tapped()
        }
        .alert("本当に削除しますか？", isPresented: $isShowAlert, actions: {
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
        if music.filePath == playDataStore.playingMusic?.filePath {
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
        playDataStore.musicChoosed(music: music, playGroup: .folder)
        playDataStore.setNextMusics(musicFilePaths: folderDataStore.folderMusicArray.map { $0.filePath })
    }
    func menuButton() -> some View {
        Menu {
            Button(action: {
                pathDataStore.folderViewNavigationPath.append(.addPlaylist)
            }, label: {
                Label("プレイリストに追加", systemImage: "text.badge.plus")
            })
            Button(action: {
                folderDataStore.selectedMusic = music
                pathDataStore.albumViewNavigationPath.append(.musicInfo)
            }, label: {
                Label("曲の情報", systemImage: "info.circle")
            })
            Divider()
            Button(action: {
                guard WillPlayRepository.insertWillPlay(newMusicFilePath: music.filePath, at: 0) else { return }
                print("succeeded")
            }, label: {
                Label("次に再生", systemImage: "text.line.first.and.arrowtriangle.forward")
            })
            Button(action: {
                guard WillPlayRepository.addWillPlay(newMusicFilePath: music.filePath) else { return }
                print("succeeded")
            }, label: {
                Label("最後に再生", systemImage: "text.line.last.and.arrowtriangle.forward")
            })
            Divider()
            Button(role: .destructive, action: {
                isShowAlert = true
            }, label: {
                Label("ファイルを削除", systemImage: "trash")
            })
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.primary)
                .frame(width: 40, height: 40)
        }
    }
    func deleteMusicFile() {
        Task {
            playDataStore.stop()
            playDataStore.playingMusic = nil
            guard FileService.fileDelete(filePath: music.filePath) else { return }
            print("DeleteSucceeded")
            guard let folderPath = folderDataStore.selectedFolder?.folderPath else { return }
            folderDataStore.folderMusicArray = await FolderRepository.getFolderMusic(folderPath: folderPath)
            folderDataStore.loadMusicSort()
        }
    }
}

#Preview {
    FolderMusicViewCell(folderDataStore: FolderDataStore.shared, playDataStore: PlayDataStore.shared, pathDataStore: PathDataStore.shared, music: Music())
}
