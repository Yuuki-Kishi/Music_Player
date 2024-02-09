//
//  Artist.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct Artist: View {
    @ObservedObject var viewModel: ViewModel
    @Binding private var artistArray: [(artistName: String, musicCount: Int)]
    
    init(viewModel: ViewModel, artistArray: Binding<[(artistName: String, musicCount: Int)]>) {
        self.viewModel = viewModel
        self._artistArray = artistArray
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(String(artistArray.count) + "人のアーティスト")
                        .font(.system(size: 15))
                        .frame(height: 20)
                    Spacer()
                }
                List {
                    ForEach(Array(artistArray.enumerated()), id: \.element.artistName) { index, artist in
                        let artistName = artist.artistName
                        NavigationLink(artistName, value: artistName)
                    }
                }
                .navigationDestination(for: String.self) { title in
                    ListMusic(viewModel: viewModel, listMusicArray: $viewModel.listMusicArray, navigationTitle: title)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                PlayingMusic(viewModel: viewModel, seekPosition: $viewModel.seekPosition, isPlay: $viewModel.isPlay, showSheet: $viewModel.showSheet)
            }
            .navigationTitle("アーティスト")
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
