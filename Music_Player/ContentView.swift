//
//  ContentView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel = ViewModel(model: FileService())
    
    var body: some View {
        TabView() {
            Music(viewModel: viewModel, musicArray: $viewModel.musicArray, directoryCheck: { Task{ await viewModel.directoryCheck() }}, sort: { viewModel.sort() })
            .tabItem {
                VStack {
                        Image(systemName: "music.note")
                        Text("ミュージック")
                    }
                }
            Artist(viewModel: viewModel, artistArray: $viewModel.artistArray)
                .tabItem {
                    VStack {
                        Image(systemName: "music.mic")
                        Text("アーティスト")
                    }
                }
                .navigationTitle("アーティスト")
            Album(viewModel: viewModel, albumArray: $viewModel.albumArray)
                .tabItem {
                    VStack {
                        Image(systemName: "square.stack")
                        Text("アルバム")
                    }
                }
            PlayList(viewModel: viewModel, playListArray: $viewModel.playListArray)
                .tabItem {
                    VStack {
                        Image(systemName: "music.note.list")
                        Text("プレイリスト")
                    }
                }
        }.accentColor(.purple)
    }
}
