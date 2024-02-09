//
//  Album.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct Album: View {
    @ObservedObject var viewModel: ViewModel
    @Binding private var albumArray: [(albumName: String, musicCount: Int)]
    
    init(viewModel: ViewModel, albumArray: Binding<[(albumName: String, musicCount: Int)]>) {
        self.viewModel = viewModel
        self._albumArray = albumArray
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(String(albumArray.count) + "枚のアルバム")
                        .lineLimit(1)
                        .font(.system(size: 15))
                        .frame(height: 20)
                        .padding(.horizontal)
                    Spacer()
                }
                List {
                    ForEach(Array(albumArray.enumerated()), id: \.element.albumName) { index, album in
                        let albumName = album.albumName
                        let musicCount = album.musicCount
                        NavigationLink(value: albumName, label: {
                            HStack {
                                Text(albumName)
                                Spacer()
                                Text(String(musicCount) + "曲")
                                    .foregroundStyle(Color.gray)
                            }
                        })
                    }
                }
                .navigationDestination(for: String.self) { title in
                    ListMusic(viewModel: viewModel, listMusicArray: $viewModel.listMusicArray, navigationTitle: title, transitionSource: "Album")
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                PlayingMusic(viewModel: viewModel, seekPosition: $viewModel.seekPosition, isPlay: $viewModel.isPlay, showSheet: $viewModel.showSheet)
            }
            .navigationTitle("アルバム")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
