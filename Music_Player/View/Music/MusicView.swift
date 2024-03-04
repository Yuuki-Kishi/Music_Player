//
//  Music.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI
import SwiftData

struct MusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Binding private var musicArray: [Music]
    @State private var isShowsProgressView = true
    @State private var isShowAlert = false
    @State private var deleteTarget: Music?
    
    init(mds: MusicDataStore, pc: PlayController, musicArray: Binding<[Music]>) {
        self.mds = mds
        self.pc = pc
        self._musicArray = musicArray
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack {
                        HStack {
                            Button(action: testPrint){
                                Image(systemName: "play.circle")
                                    .foregroundStyle(.purple)
                                Text("すべて再生 " + String(musicArray.count) + "曲")
                                Spacer()
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                    .padding(.horizontal)
                    List($musicArray) { $music in
                        let musicName = music.musicName
                        let artistName = music.artistName!
                        let albumName = music.albumName!
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
                            musicMenu(music: $music)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print("セルタップ")
                            pc.setMusic(music: music)
                            pc.setScheduleFile()
                            pc.isPlay = true
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    PlayingMusicView(pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
                }
                if isShowsProgressView {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)
                        .tint(Color.purple)
                }
            }
            .navigationTitle("ミュージック")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Menu {
                        Button(action: {
                            Task {
                                isShowsProgressView = true
                                await mds.getFile()
                                isShowsProgressView = false
                            }
                        }) {
                            Label("ファイルをスキャン", systemImage: "doc.viewfinder.fill")
                        }
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
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                })
            }
            .onAppear() {
                Task {
                    await mds.getFile()
                    isShowsProgressView = false
                }
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
                isShowAlert = true
                deleteTarget = music.wrappedValue
            }) {
                Label("ファイルを削除", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.primary)
                .frame(width: 40, height: 40)
        }
        .alert("本当に削除しますか？", isPresented: $isShowAlert, actions: {
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
                Text("この操作は取り消すことができません。この項目はゴミ箱に移動されます。")
        })
    }
    func testPrint() {
        print("すべて再生")
    }
}

