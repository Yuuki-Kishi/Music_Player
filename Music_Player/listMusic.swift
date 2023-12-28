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
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: testPrint){
                        Image(systemName: "play.circle")
                            .foregroundColor(.purple)
                        Text("すべて再生 " + String(listMusicArray.count) + "曲")
                            .foregroundColor(.primary)
                    }
                    Spacer()
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
                        .listRowBackground(Color(UIColor.systemGray6))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            ZStack {
                VStack {
                    ProgressView(value: progressValue, total: 100)
                        .foregroundColor(.purple)
                    HStack {
                        VStack {
                            Text("曲名")
                                .font(.system(size: 20.0))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Text("アーティスト名")
                                    .font(.system(size: 12.5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("アルバム名")
                                    .font(.system(size: 12.5))
                                    .frame(maxWidth: .infinity,alignment: .leading)
                            }
                        }
                        Button(action: {
                            
                        }){
                            Image(systemName: "play.fill")
                                .foregroundColor(.primary)
                        }
                            .frame(width: 50.0, height: 50.0)
                            .font(.system(size: 30.0))
                        Button(action: {
                            
                        }){
                            Image(systemName: "forward.end.fill")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
        .onAppear {
            arrayPlus()
        }
        .padding()
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
