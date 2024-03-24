//
//  didPlayMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI
import SwiftData

struct DidPlayMusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @State private var didPlayMusicArray = [Music]()
    
    init(mds: MusicDataStore, pc: PlayController) {
        self.mds = mds
        self.pc = pc
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(String(didPlayMusicArray.count) + "曲の再生履歴")
                    .padding(.horizontal)
                Spacer()
            }
            List($didPlayMusicArray) { $didPlayMusic in
                MusicCellView(mds: mds, pc: pc, musics: didPlayMusicArray, music: didPlayMusic, playingView: .didPlay)
            }
            .listStyle(.plain)
            PlayingMusicView(mds: mds, pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
        }
        .navigationTitle("再生履歴")
        .onAppear() {
            Task {
                didPlayMusicArray = await DidPlayMusicDataService.shared.readDidPlayMusics()
            }
        }
    }
}
