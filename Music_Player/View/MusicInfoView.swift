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
    @Binding private var isActive: Bool
    @State private var infoArray = [(title: String, value: String)]()
    
    init(pc: PlayController, music: Binding<Music>, isActive: Binding<Bool>) {
        self.pc = pc
        self._music = music
        self._isActive = isActive
    }
    
    var body: some View {
        List {
            ForEach(Array(infoArray.enumerated()), id: \.element.title) { index, info in
                HStack {
                    Text(info.title)
                    Spacer()
                    Text(info.value)
                }
            }
        }
        .navigationTitle("曲の情報")
        .onAppear() {
            infoArray.append((title: "曲名", value: music.musicName))
            infoArray.append((title: "アーティスト名", value: music.artistName))
            infoArray.append((title: "アルバム名", value: music.albumName))
            infoArray.append((title: "ファイルパス", value: music.filePath))
            infoArray.append((title: "ファイルサイズ", value: music.artistName))
        }
    }
}
