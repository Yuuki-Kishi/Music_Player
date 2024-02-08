//
//  Music.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct Music: View {
    @Binding private var musicArray: Array<(music: String, artist: String, album: String, belong: String)>
    private var fileImport: () -> Void
    
    init(musicArray: Array<(music: String, artist: String, album: String, belong: String)>, fileImport: @escaping () -> Void) {
        self.musicArray = musicArray
        self.fileImport = fileImport
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    HStack {
                        Button(action: testPrint){
                            Image(systemName: "play.circle")
                                .foregroundStyle(.purple)
                            Text("すべて再生 " + String(musicArray.count) + "曲")
                            Spacer()
                        }
                        .foregroundStyle(.primary)
                    }
                }
                List {
                    ForEach(Array(musicArray.enumerated()), id: \.element.music) { index, music in
                        let musicName = music.music
                        let artistName = music.artist
                        let albumName = music.album
                        ZStack {
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
                        .onTapGesture {
                            print("セルタップ")
                        }
                    }
                }
                
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                ZStack {
                    PlayingMusic()
                }
                
            }
            .navigationTitle("ミュージック")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                fileImport()
            }, label: {
                Image(systemName: "doc.viewfinder")
                    .foregroundStyle(Color.primary)
            }))
            .onAppear {
                fileImport()
            }
        }
        .padding(.horizontal)
    }
    func testPrint() {
        print("すべて再生")
    }
}
