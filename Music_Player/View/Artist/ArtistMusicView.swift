//
//  ArtistMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/24.
//

import SwiftUI

struct ArtistMusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Binding private var listMusicArray: [Music]
    @State private var navigationTitle: String
    @State private var isShowAlert = false
    @State private var deleteTarget: Music?
    @Environment(\.presentationMode) var presentation
    
    init(mds: MusicDataStore, pc: PlayController, listMusicArray: Binding<[Music]>, navigationTitle: String) {
        self.mds = mds
        self.pc = pc
        self._listMusicArray = listMusicArray
        _navigationTitle = State(initialValue: navigationTitle)
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        if !listMusicArray.isEmpty {
                            pc.musicChoosed(music: listMusicArray.randomElement()!, musics: listMusicArray, playingView: .artist)
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
            }
            List($listMusicArray) { $music in
                MusicCellView(mds: mds, pc: pc, musics: listMusicArray, music: music, playingView: .artist)
            }
            .navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    toolBarMenu()
                })
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            PlayingMusicView(mds: mds, pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
        }
        .onAppear() {
            mds.collectArtistMusic(artist: navigationTitle)
        }
    }
    func toolBarMenu() -> some View {
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
            Label("並び替え", systemImage: "arrow.up.arrow.down.circle")
        }
    }
}
