//
//  PlayList.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct PlayList: View {
    @ObservedObject var vm = ViewModel()
        
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(String(vm.playListArray.count) + "個のプレイリスト")
                        .font(.system(size: 15))
                        .frame(height: 20)
                    Spacer()
                }
                List {
                    ForEach(Array(vm.playListArray.enumerated()), id: \.element) { index, playListName in
                        NavigationLink(playListName, value: playListName)
                    }
                }
                .navigationDestination(for: String.self) { title in
//                    ListMusic(navigationTitle: title)
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
//            arrayPlus()
        }
        .padding(.horizontal)
    }
    func testPrint() {
        print("敵影感知")
    }
}

#Preview {
    PlayList()
}
