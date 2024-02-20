//
//  MusicInfoView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/20.
//

import SwiftUI

struct MusicInfoView: View {
    @ObservedObject var pc: PlayController
    @Binding private var music: Music
    
    init(pc: PlayController, music: Binding<Music>) {
        self.pc = pc
        self._music = music
    }
    
    var body: some View {
        List {
            HStack {
                Text("曲名")
                Spacer()
                Text(music.musicName)
            }
        }
        .navigationTitle("曲の情報")
    }
}
