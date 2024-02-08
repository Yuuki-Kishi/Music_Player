//
//  ContentView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        TabView() {
            Music(musicArray: viewModel.musicArray) {
                viewModel.directoryCheck()
            }
                .tabItem {
                    VStack {
                        Image(systemName: "music.note")
                        Text("ミュージック")
                    }
                }
            Artist(artistArray: viewModel.artistArray)
                .tabItem {
                    VStack {
                        Image(systemName: "music.mic")
                        Text("アーティスト")
                    }
                }
                .navigationTitle("アーティスト")
            Album(albumArray: viewModel.albumArray)
                .tabItem {
                    VStack {
                        Image(systemName: "square.stack")
                        Text("アルバム")
                    }
                }
            PlayList(playListArray: viewModel.playListArray)
                .tabItem {
                    VStack {
                        Image(systemName: "music.note.list")
                        Text("プレイリスト")
                    }
                }
        }.accentColor(.purple)
    }
}
