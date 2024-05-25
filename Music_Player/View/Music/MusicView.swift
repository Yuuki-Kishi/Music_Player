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
    @State private var isFirstAppear = false
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
                    HStack {
                        Button(action: {
                            if !musicArray.isEmpty {
                                pc.randomPlay(musics: musicArray)
                            }
                        }){
                            Image(systemName: "play.circle")
                                .foregroundStyle(.purple)
                            Text("すべて再生 " + String(musicArray.count) + "曲")
                            Spacer()
                        }
                        .foregroundStyle(.primary)
                    }
                    .padding(.horizontal)
                    List($musicArray) { $music in
                        MusicCellView(mds: mds, pc: pc, musics: musicArray, music: music, playingView: .music)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    PlayingMusicView(mds: mds, pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
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
                    toolBarMenu()
                })
            }
            .onAppear() {
                Task {
                    if musicArray.isEmpty { await mds.getFile() }
                    if !isFirstAppear { pc.setPlayingMusic(); isFirstAppear = true }
                    isShowsProgressView = false
                }
            }
        }
    }
    func toolBarMenu() -> some View {
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
            NavigationLink(destination: FavoriteMusicView(mds: mds, pc: pc), label: {
                Label("お気に入り", systemImage: "heart.fill")
            })
            NavigationLink(destination: DidPlayMusicView(mds: mds, pc: pc, didPlayMusicArray: $pc.didPlayMusics), label: {
                Label("再生履歴", systemImage: "clock.arrow.circlepath")
            })
            NavigationLink(destination: SleepTimer(pc: pc), label: {
                Label("スリープタイマー", systemImage: "timer")
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
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}

