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
                let musicName = music.musicName
                let artistName = music.artistName
                let albumName = music.albumName
                HStack {
                    VStack {
                        Text(musicName)
                            .lineLimit(1)
                            .font(.system(size: 20.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text(artistName!)
                                .lineLimit(1)
                                .font(.system(size: 12.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(albumName!)
                                .lineLimit(1)
                                .font(.system(size: 12.5))
                                .frame(maxWidth: .infinity,alignment: .leading)
                        }
                    }
                    Spacer()
                    musicMenu(music: $music)
                }
            }
            PlayingMusicView(pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
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
    func musicMenu(music: Binding<Music>) -> some View {
        Menu {
            Button(action: {testPrint()}) {
                Label("プレイリストに追加", systemImage: "text.badge.plus")
            }
            Button(action: {testPrint()}) {
                Label("ラブ", systemImage: "heart")
            }
            NavigationLink(destination: MusicInfoView(pc: pc, music: music), label: {
                Label("曲の情報", systemImage: "info.circle")
            })
            Divider()
            Button(action: {testPrint()}) {
                Label("次に再生", systemImage: "text.line.first.and.arrowtriangle.forward")
            }
            Button(action: {testPrint()}) {
                Label("最後に再生", systemImage: "text.line.last.and.arrowtriangle.forward")
            }
            Divider()
            Button(role: .destructive, action: {
                deleteTarget = music.wrappedValue
                let playlistIndex = playlistArray.firstIndex(where: {$0.playlistId == playlistId})!
                var musics = playlistArray[playlistIndex].musics
                let musicIndex = musics.firstIndex(where: {$0.filePath == deleteTarget?.filePath})!
                musics.remove(at: musicIndex)
                playlistArray[playlistIndex].musics = musics
                playlistArray[playlistIndex].musicCount -= 1
                selectMusics()
            }, label: {
                Label("プレイリストから削除", systemImage: "text.badge.minus")
            })
            Button(role: .destructive, action: {
                isShowDeleteAlert = true
                deleteTarget = music.wrappedValue
            }) {
                Label("ファイルを削除", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.primary)
        }
        .alert("本当に削除しますか？", isPresented: $isShowDeleteAlert, actions: {
            Button(role: .destructive, action: {
                if let deleteTarget {
                    Task {
                        await mds.fileDelete(filePath: deleteTarget.filePath)
                        
                    }
                }
            }, label: {
                Text("削除")
            })
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
        }, message: {
            Text("この操作は取り消すことができません。")
        })
    }
    func testPrint() {
        print("敵影感知")
    }
}
