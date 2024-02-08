//
//  PlayList.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct PlayList: View {
    @Binding private var playListArray: [(playListName: String, musicCount: Int)]
        
    init(playListArray: [(playListName: String, musicCount: Int)]) {
        self.playListArray = playListArray
    }
    
    var body: some View {
        NavigationStack {
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
                        NavigationLink(playListName, value: playListName)
                    }
                }
                .navigationDestination(for: String.self) { title in
                    ListMusic(navigationTitle: title)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                PlayingMusic()
            }
            .navigationTitle("プレイリスト")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            
        }
        .padding(.horizontal)
    }
    func testPrint() {
        print("敵影感知")
    }
}
