//
//  PlayList.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct PlayList: View {
    @ObservedObject var viewModel: ViewModel
    @Binding private var playListArray: [(playListName: String, musicCount: Int, madeDate: Date)]
    
    init(viewModel: ViewModel, playListArray: Binding<[(playListName: String, musicCount: Int, madeDate: Date)]>) {
        self.viewModel = viewModel
        self._playListArray = playListArray
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(String(playListArray.count) + "個のプレイリスト")
                        .lineLimit(1)
                        .font(.system(size: 15))
                        .frame(height: 20)
                        .padding(.horizontal)
                    Spacer()
                }
                List {
                    ForEach(Array(playListArray.enumerated()), id: \.element.playListName) { index, playList in
                        let playListName = playList.playListName
                        NavigationLink(playListName, value: playListName)
                    }
                }
                .navigationDestination(for: String.self) { title in
                    ListMusic(viewModel: viewModel, listMusicArray: $viewModel.listMusicArray, navigationTitle: title, transitionSource: "PlayList")
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                PlayingMusic(viewModel: viewModel, seekPosition: $viewModel.seekPosition, isPlay: $viewModel.isPlay, showSheet: $viewModel.showSheet)
            }
            .navigationTitle("プレイリスト")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            
        }
    }
}
