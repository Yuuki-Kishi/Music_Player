//
//  DidPlayMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI
import SwiftData

struct DidPlayMusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Environment(\.modelContext) private var modelContext
    @Query private var DPMArray: [DPMD]
    @Binding private var musicArray: [Music]
    @State private var listMusicArray = [Music]()
    
    init(mds: MusicDataStore, pc: PlayController, musicArray: Binding<[Music]>) {
        self.mds = mds
        self.pc = pc
        self._musicArray = musicArray
    }
    
    var body: some View {
        List($listMusicArray) { $music in
            MusicCellView(mds: mds, pc: pc, musicArray: $listMusicArray, music: music, playingView: .didPlay)
        }
        .listStyle(.plain)
        .navigationTitle("再生履歴")
        .onAppear() {
            print("DPMArray:", DPMArray)
            for DPMusic in DPMArray {
                if let music = musicArray.first(where: {$0.musicName == DPMusic.musicName}) {
                    listMusicArray.append(music)
                }
            }
        }
    }
}
