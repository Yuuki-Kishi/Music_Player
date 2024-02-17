//
//  ContentView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var mdsvm: MusicDataStoreViewModel
    @ObservedObject var pcvm: PlayControllerViewModel
    
    var body: some View {
        TabView() {
            MusicView(mdsvm: mdsvm, pcvm: pcvm, musicArray: $mdsvm.musicArray)
            .tabItem {
                VStack {
                        Image(systemName: "music.note")
                        Text("ミュージック")
                    }
                }
            ArtistView(mdsvm: mdsvm, pcvm: pcvm, musicArray: $mdsvm.musicArray)
                .tabItem {
                    VStack {
                        Image(systemName: "music.mic")
                        Text("アーティスト")
                    }
                }
                .navigationTitle("アーティスト")
            AlbumView(mdsvm: mdsvm, pcvm: pcvm, musicArray: $mdsvm.musicArray)
                .tabItem {
                    VStack {
                        Image(systemName: "square.stack")
                        Text("アルバム")
                    }
                }
            PlaylistView(mdsvm: mdsvm, pcvm: pcvm, playlistArray: $mdsvm.playlistArray)
                .tabItem {
                    VStack {
                        Image(systemName: "music.note.list")
                        Text("プレイリスト")
                    }
                }
        }.accentColor(.purple)
    }
}
