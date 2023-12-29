//
//  Music.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct Music: View {
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
                                Image(systemName: "ellipsis")
                                    .onTapGesture {
                                        print("ボタンタップ")
                                    }
                                    .frame(width: 30, height: 30)
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
        }
        .onAppear {
            arrayPlus()
        }
        .padding(.horizontal)
    }
    func arrayPlus() {
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
