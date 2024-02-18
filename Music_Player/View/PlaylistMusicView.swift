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
    @State private var playlistId: String
    @State private var toSelectMusicView = false
    @Environment(\.presentationMode) var presentation
    
    init(mds: MusicDataStore, pc: PlayController, navigationTitle: String, playlistId: String) {
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
            List {
                ForEach(Array(listMusicArray.enumerated()), id: \.element.musicName) { index, music in
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
                                Text(artistName)
                                    .lineLimit(1)
                                    .font(.system(size: 12.5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(albumName)
                                    .lineLimit(1)
                                    .font(.system(size: 12.5))
                                    .frame(maxWidth: .infinity,alignment: .leading)
                            }
                        }
                        Spacer()
                        Menu {
                            Button(action: {testPrint()}) {
                                Label("プレイリストに追加", systemImage: "text.badge.plus")
                            }
                            Button(action: {testPrint()}) {
                                Label("ラブ", systemImage: "heart")
                            }
                            Button(action: {testPrint()}) {
                                Label("曲の情報", systemImage: "info.circle")
                            }
                            Divider()
                            Button(action: {testPrint()}) {
                                Label("次に再生", systemImage: "text.line.first.and.arrowtriangle.forward")
                            }
                            Button(action: {testPrint()}) {
                                Label("最後に再生", systemImage: "text.line.last.and.arrowtriangle.forward")
                            }
                            Divider()
                            Button(role: .destructive, action: {testPrint()}) {
                                Label("ファイルを削除", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(Color.primary)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Menu(content: {
                        NavigationLink(destination: SelectMusicView(mds: mds, pc: pc, musicArray: $mds.musicArray, playlistId: playlistId), label: {
                            Label("曲を追加", systemImage: "plus")
                        })
                        Menu {
                            Button(action: {
                                listMusicArray.sort {$0.musicName < $1.musicName}
                            }, label: {
                                Text("曲名昇順")
                            })
                            Button(action: {
                                listMusicArray.sort {$0.musicName > $1.musicName}
                            }, label: {
                                Text("曲名降順")
                            })
                            Button(action: {
                                listMusicArray.sort {$0.editedDate < $1.editedDate}
                            }, label: {
                                Text("追加日昇順")
                            })
                            Button(action: {
                                listMusicArray.sort {$0.editedDate > $1.editedDate}
                            }, label: {
                                Text("追加日降順")
                            })
                        } label: {
                            Label("並び替え", systemImage: "arrow.up.arrow.down")
                        }
                        Divider()
                        Button(role: .destructive, action: {
                            let index = playlistArray.firstIndex(where: {$0.playlistId == playlistId})!
                            modelContext.delete(playlistArray[index])
                            self.presentation.wrappedValue.dismiss()
                        }, label: {
                            Label("プレイリストを削除", systemImage: "trash")
                        })
                    }, label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundStyle(Color.primary)
                    })
                })
            }
            PlayingMusicView(pc: pc, musicName: $pc.musicName, artistName: $pc.artistName, albumName: $pc.albumName, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
        }
        .onAppear() {
            let index = playlistArray.firstIndex(where: {$0.playlistId == playlistId})!
            listMusicArray = playlistArray[index].musics
            listMusicArray.sort {$0.musicName < $1.musicName}
        }
    }
    func testPrint() {
        print("敵影感知")
    }
}
