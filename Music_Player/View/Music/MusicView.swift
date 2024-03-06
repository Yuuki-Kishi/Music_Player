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
                        MusicCellView(mds: mds, pc: pc, music: music)
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
    func testPrint() {
        print("すべて再生")
    }
}

