//
//  listMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/28.
//

import SwiftUI

struct ListMusic: View {
    @State var listMusicArray = Singleton.shared.listMusicArray
    @State var progressValue = Singleton.shared.seekPosition
    @State var navigationTitle = Singleton.shared.navigationTitle
    
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
                }
            }
            List {
                ForEach(Array(listMusicArray.enumerated()), id: \.element.music) { index, music in
                    let musicName = music.music
                    let artistName = music.artist
                    let albumName = music.album
                    HStack {
                        VStack {
                            Text(musicName)
                                .font(.system(size: 20.0))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Text(artistName)
                                    .font(.system(size: 12.5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(albumName)
                                    .font(.system(size: 12.5))
                                    .frame(maxWidth: .infinity,alignment: .leading)
                            }
                        }
                        Spacer()
                        Menu {
                            Button(action: {testPrint()}) {
                                Label("プレイリストに追加", systemImage: "text.badge.plus")
                            }
                            Button(action: {testPrint()}) {
                                Label("ラブ", systemImage: "heart")
                            }
                            Button(action: {testPrint()}) {
                                Label("曲の情報", systemImage: "info.circle")
                            }
                            Divider()
                            Button(action: {testPrint()}) {
                                Label("次に再生", systemImage: "text.line.first.and.arrowtriangle.forward")
                            }
                            Button(action: {testPrint()}) {
                                Label("最後に再生", systemImage: "text.line.last.and.arrowtriangle.forward")
                            }
                            Divider()
                            Button(role: .destructive, action: {testPrint()}) {
                                Label("ファイルを削除", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(Color.primary)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            PlayingMusic()
        }
        .onAppear {
            arrayPlus()
        }
    }
    func arrayPlus() {
        listMusicArray = []
        let array = [(music: "曲名", artist: "アーティスト名", album: "アルバム名")]
        listMusicArray = listMusicArray + array
    }
    func testPrint() {
        print("敵影感知")
    }
}

#Preview {
    ListMusic()
}
