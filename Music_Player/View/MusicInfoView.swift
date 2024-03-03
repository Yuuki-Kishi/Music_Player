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
    @State private var infoArray = [(title: String, value: String)]()
    @State private var isShowAlert = false
    @Environment(\.presentationMode) var presentation
    
    init(pc: PlayController, music: Binding<Music>) {
        self.pc = pc
        self._music = music
    }
    
    var body: some View {
        List {
            ForEach(Array(infoArray.enumerated()), id: \.element.title) { index, info in
                HStack {
                    Text(info.title)
                    Spacer()
                    Text(info.value)
                        .lineLimit(1)
                        .truncationMode(.head)
                }
                .onTapGesture {
                    if index == 3 {
                        UIPasteboard.general.string = info.value
                        isShowAlert = true
                    }
                }
                .alert("ファイルパスをコピーしました", isPresented: $isShowAlert, actions: {
                    Button(action: { isShowAlert = false }, label: {
                        Text("OK")
                    })
                })
            }
        }
        .navigationTitle("曲の情報")
        .onAppear() {
            infoArray.append((title: "曲名", value: music.musicName))
            infoArray.append((title: "アーティスト名", value: music.artistName ?? ""))
            infoArray.append((title: "アルバム名", value: music.albumName ?? ""))
            infoArray.append((title: "ファイルパス", value: music.filePath ?? ""))
            infoArray.append((title: "ファイルサイズ", value: music.fileSize ?? ""))
        }
    }
}
