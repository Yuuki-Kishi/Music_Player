//
//  AlbumMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/24.
//

import SwiftUI

struct AlbumMusicView: View {
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
            .navigationTitle(navigationTitle)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .onAppear() {
                mds.collectAlbumMusic(album: navigationTitle)
            }
            PlayingMusicView(pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
        }
    }
    func testPrint() {
        print("敵影感知")
    }
}
