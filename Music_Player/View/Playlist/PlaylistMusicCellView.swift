//
//  SwiftUIView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/29.
//
import SwiftUI

struct PlaylistMusicCellView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @State var music: Music
    @State private var musics: [Music]
    @State private var isShowMusicAlert = false
    @State private var isShowPlaylistMusicAlert = false
    @State private var deleteTarget: Music?
    @State private var playlistData: PlaylistData
    
    init(mds: MusicDataStore, pc: PlayController, musics: [Music], music: Music, playlistData: PlaylistData) {
        self.mds = mds
        self.pc = pc
        _musics = State(initialValue: musics)
        _music = State(initialValue: music)
        _playlistData = State(initialValue: playlistData)
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(music.musicName ?? "不明なミュージック")
                    .lineLimit(1)
                    .font(.system(size: 20.0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(musicNameColor())
                HStack {
                    Text(music.artistName ?? "不明なアーティスト")
                        .lineLimit(1)
                        .font(.system(size: 12.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.gray)
                    Text(music.albumName ?? "不明なアルバム")
                        .lineLimit(1)
                        .font(.system(size: 12.5))
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundStyle(Color.gray)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                pc.musicChoosed(music: music, musics: musics, playingView: .playlist)
            }
            Spacer()
            Text(secToMin(second:music.musicLength!))
                .foregroundStyle(Color.gray)
            musicMenu(music: $music)
        }
    }
    func musicNameColor() -> Color {
        let pcMusicPath = PlayController.shared.music?.filePath
        var textColor = Color.primary
        if pcMusicPath == music.filePath { textColor = .purple }
        return textColor
    }
    func secToMin(second: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        if second < 3600 { dateFormatter.allowedUnits = [.minute, .second] }
        else { dateFormatter.allowedUnits = [.hour, .minute, .second] }
        dateFormatter.zeroFormattingBehavior = .pad
        return dateFormatter.string(from: second)!
    }
    func musicMenu(music: Binding<Music>) -> some View {
        Menu {
            NavigationLink(destination: AddPlaylistView(music: music), label: {
                Label("プレイリストに追加", systemImage: "text.badge.plus")
            })
            NavigationLink(destination: MusicInfoView(pc: pc, music: music), label: {
                Label("曲の情報", systemImage: "info.circle")
            })
            Divider()
            Button(action: {pc.addWPMFirst(music: music.wrappedValue)}) {
                Label("次に再生", systemImage: "text.line.first.and.arrowtriangle.forward")
            }
            Button(action: {pc.addWPMLast(music: music.wrappedValue)}) {
                Label("最後に再生", systemImage: "text.line.last.and.arrowtriangle.forward")
            }
            Divider()
            Button(role: .destructive, action: {
                isShowPlaylistMusicAlert = true
                deleteTarget = music.wrappedValue
            }, label: {
                Label("プレイリストから除外", systemImage: "text.badge.minus")
            })
            Button(role: .destructive, action: {
                isShowMusicAlert = true
                deleteTarget = music.wrappedValue
            }) {
                Label("ファイルを削除", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.primary)
                .frame(width: 40, height: 40)
        }
        .alert("本当に除外しますか？", isPresented: $isShowPlaylistMusicAlert, actions: {
            Button(role: .destructive, action: {
                if let deleteTarget {
                    Task {
                        if let index = musics.firstIndex(where: {$0 == deleteTarget}) {
                            musics.remove(at: index)
                            await PlaylistDataService.shared.updatePlaylistData(playlistId: playlistData.playlistId, playlistName: playlistData.playlistName, musics: musics)
                            mds.listMusicArray = await PlaylistDataService.shared.readPlaylistMusics(playlistId: playlistData.playlistId)
                        }
                    }
                }
            }, label: {
                Text("除外")
            })
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
        }, message: {
            Text("この操作は取り消すことができません。")
        })
        .alert("本当に削除しますか？", isPresented: $isShowMusicAlert, actions: {
            Button(role: .destructive, action: {
                if let deleteTarget { Task { await mds.fileDelete(filePath: deleteTarget.filePath) }}
            }, label: {
                Text("削除")
            })
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
        }, message: {
                Text("この操作は取り消すことができません。この項目はゴミ箱に移動されます。")
        })
    }
}

