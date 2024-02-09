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
                        .font(.system(size: 15))
                        .frame(height: 20)
                    Spacer()
                }
                List {
                    ForEach(Array(albumArray.enumerated()), id: \.element.albumName) { index, album in
                        let albumName = album.albumName
                        NavigationLink(albumName, value: albumName)
                    }
                }
                .navigationDestination(for: String.self) { title in
                    ListMusic(viewModel: viewModel, listMusicArray: $viewModel.listMusicArray, navigationTitle: title)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                PlayingMusic(viewModel: viewModel, seekPosition: $viewModel.seekPosition, isPlay: $viewModel.isPlay, showSheet: $viewModel.showSheet)
            }
            .navigationTitle("アルバム")
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
