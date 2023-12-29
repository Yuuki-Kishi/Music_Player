//
//  listMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/28.
//

import SwiftUI

struct listMusic: View {
    @State var listMusicArray = Singleton.shared.listMusicArray
    @State var progressValue = Singleton.shared.progressValue
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
                        Button(action: {
                            testPrint()
                        }){
                            Image(systemName: "ellipsis")
                        }
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            playingMusic()
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
    listMusic()
}
