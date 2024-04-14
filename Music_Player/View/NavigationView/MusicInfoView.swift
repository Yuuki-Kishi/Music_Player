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
    
    init(pc: PlayController, music: Binding<Music>) {
        self.pc = pc
        self._music = music
    }
    
    var body: some View {
        List {
            HStack {
                Text("曲名")
                Spacer()
                Text(music.musicName!)
            }
            HStack {
                Text("アーティスト名")
                Spacer()
                Text(music.artistName ?? "不明")
            }
            HStack {
                Text("アルバム名")
                Spacer()
                Text(music.albumName ?? "不明")
            }
            HStack {
                Text("曲の長さ")
                Spacer()
                Text(secToMin(second: music.musicLength ?? 0))
            }
            HStack {
                Text("ファイルサイズ")
                Spacer()
                Text(music.fileSize ?? "0MB")
            }
            HStack {
                Text("ファイルパス")
                Spacer()
                Text(music.filePath ?? "不明")
                    .lineLimit(1)
                    .truncationMode(.head)
            }
            .onTapGesture {
                if let filePath = music.filePath {
                    UIPasteboard.general.string = filePath
                    isShowAlert = true
                }
            }
            .alert("ファイルパスをコピーしました", isPresented: $isShowAlert, actions: {
                Button(action: { isShowAlert = false }, label: {
                    Text("OK")
                })
            })
        }
        .navigationTitle("曲の情報")
    }
    func secToMin(second: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        if second < 3600 { dateFormatter.allowedUnits = [.minute, .second] }
        else { dateFormatter.allowedUnits = [.hour, .minute, .second] }
        dateFormatter.zeroFormattingBehavior = .pad
        return dateFormatter.string(from: second)!
    }
}
