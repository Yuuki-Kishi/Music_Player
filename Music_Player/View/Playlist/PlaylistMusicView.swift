//
//  PlaylistMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/18.
//

import SwiftUI
import SwiftData

struct PlaylistMusicView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Query private var playlistArray: [PlaylistData]
    @State private var listMusicArray = [Music]()
    @State private var navigationTitle: String
    @State private var playlistId: UUID
    @State private var toSelectMusicView = false
    @State private var isShowDeleteAlert = false
    @State private var isShowRenameAlert = false
    @State private var deleteTarget: Music?
    @State private var text = ""
    @Environment(\.presentationMode) var presentation
    let fileService = FileService()
    
    init(mds: MusicDataStore, pc: PlayController, navigationTitle: String, playlistId: UUID) {
        self.mds = mds
        self.pc = pc
        _navigationTitle = State(initialValue: navigationTitle)
        _playlistId = State(initialValue: playlistId)
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: testPrint){
                        Image(systemName: "play.circle")
                            .foregroundStyle(.purple)
                        Text("すべて再生 " + String(listMusicArray.count) + "曲")
                        Spacer()
                    }
                    .foregroundStyle(.primary)
                    .padding(.horizontal)
                }
            }
            List($listMusicArray) { $music in
                MusicCellView(mds: mds, pc: pc, music: music)
            }
            PlayingMusicView(mds: mds, pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
        }
        .navigationTitle(navigationTitle)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Menu {
                    NavigationLink(destination: SelectMusicView(mds: mds, pc: pc, musicArray: $mds.musicArray, playlistId: $playlistId), label: {
                        Label("曲を追加", systemImage: "plus")
                    })
                    Button(action: { text = navigationTitle; isShowRenameAlert.toggle() }, label: {
                        Label("名前を変更する", systemImage: "arrow.triangle.2.circlepath")
                    })
                    Menu {
                        Button(action: { mds.musicSort(method: .nameAscending) }, label: {
                            Text("曲名昇順")
                        })
                        Button(action: { mds.musicSort(method: .nameDescending) }, label: {
                            Text("曲名降順")
                        })
                        Button(action: { mds.musicSort(method: .dateAscending) }, label: {
                            Text("追加日昇順")
                        })
                        Button(action: { mds.musicSort(method: .dateDescending) }, label: {
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
                    Button("作成") {
                        let index = playlistArray.firstIndex(where: {$0.playlistId == playlistId})!
                        let musicCount = playlistArray[index].musicCount
                        let musics = playlistArray[index].musics
                        navigationTitle = text
                        let playlist = PlaylistData(playlistId: playlistId, playlistName: navigationTitle, musicCount: musicCount, musics: musics)
                        modelContext.delete(playlistArray[index])
                        modelContext.insert(playlist)
                    }
                }, message: {
                    Text("プレイリストの新しい名前を入力してください。")
                })
                .alert("本当に削除しますか？", isPresented: $isShowDeleteAlert, actions: {
                    Button("キャンセル", role: .cancel) {}
                    Button("削除", role: .destructive) {
                        let index = playlistArray.firstIndex(where: {$0.playlistId == playlistId})!
                        modelContext.delete(playlistArray[index])
                        self.presentation.wrappedValue.dismiss()
                    }
                }, message: {
                    Text("作成するプレイリストの名前を入力してください。")
                })
            })
        }
        .onAppear() {
            selectMusics()
        }
    }
    func selectMusics() {
        listMusicArray = []
        if let index = playlistArray.firstIndex(where: {$0.playlistId == playlistId}) {
            navigationTitle = playlistArray[index].playlistName
            if !playlistArray[index].musics.isEmpty {
                listMusicArray = playlistArray[index].musics
                listMusicArray.sort {$0.musicName < $1.musicName}
            }
        }
    }
    func testPrint() {
        print("敵影感知")
    }
}
