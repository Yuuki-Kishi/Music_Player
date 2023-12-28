//
//  Album.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct Album: View {
    @State var progressValue = Singleton.shared.progressValue
    @State var albumArray = Singleton.shared.albumArray
    
    var body: some View {
        VStack {
            HStack {
                Text(String(albumArray.count) + "枚のアルバム")
                    .font(.system(size: 15))
                    .frame(height: 20)
                Spacer()
            }
            List {
                ForEach(Array(albumArray.enumerated()), id: \.element.albumName) { index, album in
                    let albumName = album.albumName
                    let musicCount = String(album.musicCount) + "曲"
                    HStack {
                        Text(albumName)
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(musicCount)
                            .font(.system(size: 15))
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(UIColor.systemGray3))
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
        albumArray = []
        let array = [(albumName: "アルバム名", musicCount: 5)]
        albumArray = albumArray + array
    }
    func testPrint() {
        print("敵影感知")
    }
}

#Preview {
    Album()
}
