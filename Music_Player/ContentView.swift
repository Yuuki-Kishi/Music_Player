//
//  ContentView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    
    var body: some View {
        TabView() {
            MusicView(mds: mds, pc: pc, musicArray: $mds.musicArray)
            .tabItem {
                VStack {
                        Image(systemName: "music.note")
                        Text("ミュージック")
                    }
                }
            ArtistView(mds: mds, pc: pc, artistArray: $mds.artistArray)
                .tabItem {
                    VStack {
                        Image(systemName: "music.mic")
                        Text("アーティスト")
                    }
                }
                .navigationTitle("アーティスト")
            AlbumView(mds: mds, pc: pc, albumArray: $mds.albumArray)
                .tabItem {
                    VStack {
                        Image(systemName: "square.stack")
                        Text("アルバム")
                    }
                }
            PlaylistView(mds: mds, pc: pc)
                .tabItem {
                    VStack {
                        Image(systemName: "music.note.list")
                        Text("プレイリスト")
                    }
                }
        }.accentColor(.purple)
    }
}
