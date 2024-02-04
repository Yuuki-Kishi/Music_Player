//
//  Music.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct Music: View {
    let fileManager = FileManager.default
    @State var musicArray = Singleton.shared.musicArray
    @State var progressValue = Singleton.shared.seekPosition
    @State var showSheet = Singleton.shared.showSheet
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
            .onAppear {
                let directories = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                let documentDirectory = directories.first
                let fileURL = documentDirectory!.appendingPathComponent("explain.txt")
                let content = "ここに書いた説明を読めるようにするために、このファイルを「このiPhone内」のフォルダの中に保存できるようにしたい。"
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let filePath = documentsPath + "/explain.txt"
                if !fileManager.fileExists(atPath: filePath) {
                    do {
                        try content.write(to: fileURL, atomically: true, encoding: .utf8)
                    } catch {
                        print(error)
                    }
                }
                let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                let docDir = dir.first
                let path = docDir?.absoluteString
                print("fileURL:", fileURL, "path:", path!)
                do {
                    let data = try fileManager.contentsOfDirectory(atPath: path!)
                    print("data:", data)
                } catch {
                    print(error)
                }
            }
        }
        
        .padding(.horizontal)
    }
    
    func arrayPlus(music: String, artist: String, album: String) {
        musicArray = []
        let array = [(music: "曲名", artist: "アーティスト名", album: "アルバム名")]
        musicArray = musicArray + array
    }
    func testPrint() {
        print("すべて再生")
    }
}

#Preview {
    Music()
}
