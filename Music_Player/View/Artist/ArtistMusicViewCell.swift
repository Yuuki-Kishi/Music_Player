//
//  ArtistMusicViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import SwiftUI

struct ArtistMusicViewCell: View {
    @ObservedObject var artistDataStore: ArtistDataStore
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
    func secToMin(second: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        if second < 3600 { dateFormatter.allowedUnits = [.minute, .second] }
        else { dateFormatter.allowedUnits = [.hour, .minute, .second] }
        dateFormatter.zeroFormattingBehavior = .pad
        return dateFormatter.string(from: second)!
    }
    func tapped() {
        playDataStore.musicChoosed(music: music, playGroup: .artist)
        playDataStore.setNextMusics(musicFilePaths: artistDataStore.artistMusicArray.map { $0.filePath })
    }
    func menuButton() -> some View {
        Menu {
            Button(action: {
                artistDataStore.selectedMusic = music
                pathDataStore.artistViewNavigationPath.append(.addPlaylist)
            }, label: {
                Label("プレイリストに追加", systemImage: "text.badge.plus")
            })
            Button(action: {
                artistDataStore.selectedMusic = music
                pathDataStore.artistViewNavigationPath.append(.musicInfo)
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
            guard let artistName = artistDataStore.selectedArtist?.artistName else { return }
            artistDataStore.artistMusicArray = await ArtistRepository.getArtistMusic(artistName: artistName)
            artistDataStore.loadMusicSort()
        }
    }
}

#Preview {
    ArtistMusicViewCell(artistDataStore: ArtistDataStore.shared, playDataStore: PlayDataStore.shared, pathDataStore: PathDataStore.shared, music: Music())
}
