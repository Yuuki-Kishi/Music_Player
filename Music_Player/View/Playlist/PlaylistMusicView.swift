//
//  PlaylistMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/18.
//

import SwiftUI
import SwiftData

struct PlaylistMusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Binding private var listMusicArray: [Music]
    @State private var playlistData: PlaylistData
    @State private var toSelectMusicView = false
    @State private var isShowDeleteAlert = false
    @State private var isShowRenameAlert = false
    @State private var deleteTarget: Music?
    @State private var text = ""
    @Environment(\.presentationMode) var presentation
    let fileService = FileService()
    
    init(mds: MusicDataStore, pc: PlayController, listMusicArray: Binding<[Music]>, playlistData: PlaylistData) {
        self.mds = mds
        self.pc = pc
        self._listMusicArray = listMusicArray
        _playlistData = State(initialValue: playlistData)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    if !listMusicArray.isEmpty {
                        pc.musicChoosed(music: listMusicArray.randomElement()!, musics: listMusicArray, playingView: .playlist)
                    }
                }){
                    Image(systemName: "play.circle")
                        .foregroundStyle(.purple)
                    Text("すべて再生 " + String(listMusicArray.count) + "曲")
                    Spacer()
                }
                .foregroundStyle(.primary)
                .padding(.horizontal)
            }
            List($listMusicArray) { $music in
                PlaylistMusicCellView(mds: mds, pc: pc, musics: listMusicArray, music: music, playlistData: playlistData)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            PlayingMusicView(mds: mds, pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
        }
        .navigationTitle(playlistData.playlistName)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .onAppear() {
            Task {
                listMusicArray = await PlaylistDataService.shared.readPlaylistMusics(playlistId: playlistData.playlistId)
                listMusicArray.sort {$0.musicName ?? "不明" < $1.musicName ?? "不明"}
            }
        }
    }
    func toolBarMenu() -> some View{
        Menu {
            NavigationLink(destination: PlaylistSelectMusicView(mds: mds, pc: pc, playlistData: playlistData), label: {
                Label("曲を追加", systemImage: "plus")
            })
            Button(action: { text = playlistData.playlistName; isShowRenameAlert.toggle() }, label: {
                Label("名前を変更する", systemImage: "arrow.triangle.2.circlepath")
            })
            Menu {
                Button(action: { mds.listMusicSort(method: .nameAscending) }, label: {
                    Text("曲名昇順")
                })
                Button(action: { mds.listMusicSort(method: .nameDescending) }, label: {
                    Text("曲名降順")
                })
                Button(action: { mds.listMusicSort(method: .dateAscending) }, label: {
                    Text("追加日昇順")
                })
                Button(action: { mds.listMusicSort(method: .dateDescending) }, label: {
                    Text("追加日降順")
                })
            } label: {
                Label("並び替え", systemImage: "arrow.up.arrow.down")
            }
            Divider()
            Button(role: .destructive, action: { isShowDeleteAlert.toggle() }, label: {
                Label("プレイリストを削除", systemImage: "trash")
            })
        } label: {
            Image(systemName: "ellipsis.circle")
        }
        .alert("プレイリスト名の変更", isPresented: $isShowRenameAlert, actions: {
            TextField("新しい名前", text: $text)
            Button("キャンセル", role: .cancel) {}
            Button("変更") {
                Task { await PlaylistDataService.shared.updatePlaylistData(playlistId: playlistData.playlistId, playlistName: text, musics: playlistData.musics) }
            }
        }, message: {
            Text("プレイリストの新しい名前を入力してください。")
        })
        .alert("本当に削除しますか？", isPresented: $isShowDeleteAlert, actions: {
            Button("キャンセル", role: .cancel) {}
            Button("削除", role: .destructive) {
                Task {
                    await PlaylistDataService.shared.deletePlaylistData(playlistData: playlistData)
                    presentation.wrappedValue.dismiss()
                }
            }
        }, message: {
            Text("作成するプレイリストの名前を入力してください。")
        })
    }
}
