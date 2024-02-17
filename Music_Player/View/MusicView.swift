//
//  Music.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct MusicView: View {
    @ObservedObject var mdsvm: MusicDataStoreViewModel
    @ObservedObject var pcvm: PlayControllerViewModel
    @Binding private var musicArray: [Music]
    
    init(mdsvm: MusicDataStoreViewModel, pcvm: PlayControllerViewModel, musicArray: Binding<[Music]>) {
        self.mdsvm = mdsvm
        self.pcvm = pcvm
        self._musicArray = musicArray
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
                .padding(.horizontal)
                List {
                    ForEach(Array(musicArray.enumerated()), id: \.element.musicName) { index, music in
                        let musicName = music.musicName
                        let artistName = music.artistName
                        let albumName = music.albumName
                        ZStack {
                            HStack {
                                VStack {
                                    Text(musicName)
                                        .lineLimit(1)
                                        .font(.system(size: 20.0))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    HStack {
                                        Text(artistName)
                                            .lineLimit(1)
                                            .font(.system(size: 12.5))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(albumName)
                                            .lineLimit(1)
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
                    PlayingMusicView(pcvm: pcvm, musicName: $pcvm.musicName, artistName: $pcvm.artistName, albumName: $pcvm.albumName, seekPosition: $pcvm.seekPosition, isPlay: $pcvm.isPlay)
                }
                
            }
            .navigationTitle("ミュージック")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Menu {
                    Button(action: {testPrint()}) {
                        Label("ファイルをスキャン", systemImage: "doc.viewfinder")
                    }
                    Menu {
                        Button(action: { mdsvm.sort(method: 0) }, label: {
                            HStack {
                                Text("曲名昇順")
                                Image(systemName: "a.circle")
                                    .foregroundStyle(.primary)
                                Image(systemName: "arrow.down")
                                    .foregroundStyle(.primary)
                            }
                        })
                        Button(action: { mdsvm.sort(method: 1) }, label: {
                            HStack {
                                Text("曲名降順")
                                Image(systemName: "z.circle")
                                    .foregroundStyle(.primary)
                                Image(systemName: "arrow.up")
                                    .foregroundStyle(.primary)
                            }
                        })
                        Button(action: { mdsvm.sort(method: 2) }, label: {
                            HStack {
                                Text("追加日昇順")
                                Image(systemName: "clock")
                                    .foregroundStyle(.primary)
                                Image(systemName: "arrow.down")
                                    .foregroundStyle(.primary)
                            }
                        })
                        Button(action: { mdsvm.sort(method: 3) }, label: {
                            HStack {
                                Text("追加日降順")
                                Image(systemName: "clock")
                                    .foregroundStyle(.primary)
                                Image(systemName: "arrow.up")
                                    .foregroundStyle(.primary)
                            }
                        })
                    } label: {
                        HStack {
                            Text("並び替え")
                            Image(systemName: "arrow.up.arrow.down")
                                .foregroundStyle(Color.primary)
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(Color.primary)
                }
            )
            .onAppear() {
                Task {
                    await mdsvm.getFile()
                }
            }
        }
    }
    func testPrint() {
        print("すべて再生")
    }
}
