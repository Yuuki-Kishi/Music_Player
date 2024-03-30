//
//  FolderMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/06.
//

import SwiftUI

struct FolderMusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Binding var listMusicArray: [Music]
    @State var navigationTitle: String
    
    init(mds: MusicDataStore, pc: PlayController, listMusicArray: Binding<[Music]>, navigationTitle: String) {
        self.mds = mds
        self.pc = pc
        self._listMusicArray = listMusicArray
        _navigationTitle = State(initialValue: navigationTitle)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    if !listMusicArray.isEmpty {
                        pc.musicChoosed(music: listMusicArray.randomElement()!, musics: listMusicArray, playingView: .album)
                    }
                }){
                    Image(systemName: "play.circle")
                        .foregroundStyle(.purple)
                    Text("すべて再生 " + String(listMusicArray.count) + "曲")
                    Spacer()
                }
                .foregroundStyle(Color.primary)
            }
            .padding(.horizontal)
            List($listMusicArray) { $music in
                MusicCellView(mds: mds, pc: pc, musics: listMusicArray, music: music, playingView: .folder)
            }
            PlayingMusicView(mds: mds, pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
        }
        .listStyle(.plain)
        .navigationTitle(navigationTitle)
        .onAppear() {
            mds.collectFolderMusic(folder: navigationTitle)
        }
    }
}
