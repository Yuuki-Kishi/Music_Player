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
        NavigationStack {
            VStack {
                HStack {
                    Text(String(playListArray.count) + "個のプレイリスト")
                        .font(.system(size: 15))
                        .frame(height: 20)
                    Spacer()
                }
                List {
                    ForEach(Array(playListArray.enumerated()), id: \.element) { index, playListName in
                        NavigationLink(playListName, value: playListName)
                    }
                }
                .navigationDestination(for: String.self) { title in
                    listMusic(navigationTitle: title)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                playingMusic()
            }
            .navigationTitle("プレイリスト")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            arrayPlus()
        }
        .padding(.horizontal)
    }
    func arrayPlus() {
        playListArray = []
        playListArray.append("プレイリスト名")
    }
    func testPrint() {
        print("敵影感知")
    }
}

#Preview {
    PlayList()
}
