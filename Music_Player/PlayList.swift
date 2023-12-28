//
//  PlayList.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct PlayList: View {
    @State var progressValue = Singleton.shared.progressValue
    @State var playListArray = Singleton.shared.playListName
        
    var body: some View {
        VStack {
            HStack {
                Text(String(playListArray.count) + "個のプレイリスト")
                    .font(.system(size: 15))
                    .frame(height: 20)
                Spacer()
            }
            List {
                ForEach(Array(playListArray.enumerated()), id: \.element.playListName) { index, playList in
                    let playListName = playList.playListName
                    let musicCount = String(playList.musicCount) + "曲"
                    HStack {
                        Text(playListName)
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
            .background(Color.white)
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
        playListArray = []
        let array = [(playListName: "プレイリスト名", musicCount: 10)]
        playListArray = playListArray + array
    }
    func testPrint() {
        print("敵影感知")
    }
}

#Preview {
    PlayList()
}
