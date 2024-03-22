//
//  WillPlayMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI

struct WillPlayMusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    
    init(mds: MusicDataStore, pc: PlayController) {
        self.mds = mds
        self.pc = pc
    }
    
    var body: some View {
        List($pc.willPlayMusics) { $music in
            MusicCellView(mds: mds, pc: pc, musics: pc.willPlayMusics, music: music, playingView: .willPlay)
        }
        .listStyle(.plain)
        .background(Color.clear)
        .navigationTitle("再生予定曲")
    }
}
