//
//  ContentView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab = 1
    @State var navigationTitle = "ミュージック"
    @State var musicArray = [(music: String, artist: String, album: String)]()
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                Music()
                    .tabItem {
                        VStack {
                            Image(systemName: "music.note")
                            Text("ミュージック")
                        }.foregroundColor(.purple)
                    }.tag(1)
                Artist()
                    .tabItem {
                        VStack {
                            Image(systemName: "music.mic")
                            Text("アーティスト")
                        }
                    }.tag(2)
                Album()
                    .tabItem {
                        VStack {
                            Image(systemName: "square.stack")
                            Text("アルバム")
                        }
                    }.tag(3)
                PlayList()
                    .tabItem {
                        VStack {
                            Image(systemName: "music.note.list")
                            Text("プレイリスト")
                        }
                    }.tag(4)
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedTab) { tab in
                switch tab {
                case 1:
                    navigationTitle = "ミュージック"
                case 2:
                    navigationTitle = "アーティスト"
                case 3:
                    navigationTitle = "アルバム"
                default:
                    navigationTitle = "プレイリスト"
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
