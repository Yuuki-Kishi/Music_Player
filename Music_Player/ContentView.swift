//
//  ContentView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView() {
            Music()
                .tabItem {
                    VStack {
                        Image(systemName: "music.note")
                        Text("ミュージック")
                    }
                }
            Artist()
                .tabItem {
                    VStack {
                        Image(systemName: "music.mic")
                        Text("アーティスト")
                    }
                }
                .navigationTitle("アーティスト")
            Album()
                .tabItem {
                    VStack {
                        Image(systemName: "square.stack")
                        Text("アルバム")
                    }
                }
            PlayList()
                .tabItem {
                    VStack {
                        Image(systemName: "music.note.list")
                        Text("プレイリスト")
                    }
                }
        }.accentColor(.purple)
    }
}

#Preview {
    ContentView()
}
