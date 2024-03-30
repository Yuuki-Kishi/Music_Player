//
//  MusicCellView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/06.
//

import SwiftUI

struct MusicCellView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @State var music: Music
    @State private var musics: [Music]
    @State private var isShowMusicAlert = false
    @State private var isShowWillPlayMusicAlert = false
    @State private var deleteTarget: Music?
    @State private var playingView: PlayController.playingView
    
    init(mds: MusicDataStore, pc: PlayController, musics: [Music], music: Music, playingView: PlayController.playingView) {
        self.mds = mds
        self.pc = pc
        _musics = State(initialValue: musics)
        _music = State(initialValue: music)
        _playingView = State(initialValue: playingView)
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(music.musicName ?? "不明なミュージック")
                    .lineLimit(1)
                    .font(.system(size: 20.0))
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                tapped()
            }
            Spacer()
            Text(secToMin(second:music.musicLength!))
                .foregroundStyle(Color.gray)
            if playingView == .willPlay { willPlayMenu(music: $music) }
            else { musicMenu(music: $music) }
        }
    }
    func tapped() {
        switch playingView {
        case .willPlay:
            pc.choosedWillPlayMusic(music: music)
        case .didPlay:
            pc.choosedDidPlayMusic(music: music)
        default:
            pc.musicChoosed(music: music, musics: musics, playingView: playingView)
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
    func willPlayMenu(music: Binding<Music>) -> some View {
        Menu {
            NavigationLink(destination: AddPlaylistView(music: music), label: {
                Label("プレイリストに追加", systemImage: "text.badge.plus")
            })
            NavigationLink(destination: MusicInfoView(pc: pc, music: music), label: {
                Label("曲の情報", systemImage: "info.circle")
            })
            Divider()
            Button(role: .destructive, action: {
                isShowWillPlayMusicAlert = true
                deleteTarget = music.wrappedValue
            }) {
                Label("ファイルを削除", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.primary)
                .frame(width: 40, height: 40)
        }
        .alert("本当に削除しますか？", isPresented: $isShowWillPlayMusicAlert, actions: {
            Button(role: .destructive, action: {
                if let deleteTarget { Task { await mds.fileDelete(filePath: deleteTarget.filePath) }}
            }, label: {
                Text("削除")
            })
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
        })
    }
//    func playlistMenu(music: Binding<Music>) -> some View {
//        Menu {
//            NavigationLink(destination: AddPlaylistView(music: music), label: {
//                Label("プレイリストに追加", systemImage: "text.badge.plus")
//            })
//            NavigationLink(destination: MusicInfoView(pc: pc, music: music), label: {
//                Label("曲の情報", systemImage: "info.circle")
//            })
//            Divider()
//            Button(action: {pc.addWPMFirst(music: music.wrappedValue)}) {
//                Label("次に再生", systemImage: "text.line.first.and.arrowtriangle.forward")
//            }
//            Button(action: {pc.addWPMLast(music: music.wrappedValue)}) {
//                Label("最後に再生", systemImage: "text.line.last.and.arrowtriangle.forward")
//            }
//            Divider()
//            Button(role: .destructive, action: {
//                isShowPlaylistAlert = true
//                deleteTarget = music.wrappedValue
//            }, label: {
//                Label("プレイリストから削除", systemImage: "text.badge.minus")
//            })
//            Button(role: .destructive, action: {
//                isShowMusicAlert = true
//                deleteTarget = music.wrappedValue
//            }) {
//                Label("ファイルを削除", systemImage: "trash")
//            }
//        } label: {
//            Image(systemName: "ellipsis")
//                .foregroundStyle(Color.primary)
//                .frame(width: 40, height: 40)
//        }
//        .alert("本当に除外しますか？", isPresented: $isShowPlaylistAlert, actions: {
//            Button(role: .destructive, action: {
//                if let deleteTarget { deletePlaylistMusic(music: deleteTarget) }
//            }, label: {
//                Text("削除")
//            })
//            Button(role: .cancel, action: {}, label: {
//                Text("キャンセル")
//            })
//        })
//        .alert("本当に削除しますか？", isPresented: $isShowMusicAlert, actions: {
//            Button(role: .destructive, action: {
//                if let deleteTarget { Task { await mds.fileDelete(filePath: deleteTarget.filePath) }}
//            }, label: {
//                Text("削除")
//            })
//            Button(role: .cancel, action: {}, label: {
//                Text("キャンセル")
//            })
//        }, message: {
//                Text("この操作は取り消すことができません。この項目はゴミ箱に移動されます。")
//        })
//    }
}
