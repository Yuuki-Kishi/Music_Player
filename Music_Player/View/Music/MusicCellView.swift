//
//  MusicCellView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/06.
//

import SwiftUI

struct MusicCellView: View {
    @StateObject var musicDataStore = MusicDataStore.shared
    @StateObject var playDataStore = PlayDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
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
        if music == playDataStore.playingMusic {
            return .accent
        } else {
            return .primary
        }
    }
    func tapped() {
        playDataStore.musicChoosed(music: music)
        playDataStore.setNextMusics(musicFilePaths: musicDataStore.musicArray.map { $0.filePath })
    }
    func secToMin(second: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        if second < 3600 { dateFormatter.allowedUnits = [.minute, .second] }
        else { dateFormatter.allowedUnits = [.hour, .minute, .second] }
        dateFormatter.zeroFormattingBehavior = .pad
        return dateFormatter.string(from: second)!
    }
    func menuButton() -> some View {
        Menu {
            Button(action: {
                musicDataStore.selectedMusic = music
                pathDataStore.musicViewNavigationPath.append(.addPlaylist)
            }, label: {
                Label("プレイリストに追加", systemImage: "text.badge.plus")
            })
            Button(action: {
                musicDataStore.selectedMusic = music
                pathDataStore.musicViewNavigationPath.append(.musicInfo)
            }, label: {
                Label("曲の情報", systemImage: "info.circle")
            })
            Divider()
            Button(action: {
                if WillPlayRepository.insertWillPlay(newMusicFilePaths: [music.filePath], at: 0) {
                    print("succeeded")
                }
            }, label: {
                Label("次に再生", systemImage: "text.line.first.and.arrowtriangle.forward")
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
        if FileService.fileDelete(filePath: music.filePath) {
            print("DeleteSucceeded")
        }
    }
}

#Preview {
    MusicCellView(music: Music())
}
