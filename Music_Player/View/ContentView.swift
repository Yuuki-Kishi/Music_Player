//
//  ContentView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewDataStore = ViewDataStore.shared
    
    var body: some View {
        TabView() {
            MusicView()
                .tabItem {
                    VStack {
                        Image(systemName: "music.note")
                        Text("ミュージック")
                    }
                }
            ArtistView()
                .tabItem {
                    VStack {
                        Image(systemName: "music.mic")
                        Text("アーティスト")
                    }
                }
                .navigationTitle("アーティスト")
            AlbumView()
                .tabItem {
                    VStack {
                        Image(systemName: "square.stack")
                        Text("アルバム")
                    }
                }
            PlaylistView()
                .tabItem {
                    VStack {
                        Image(systemName: "music.note.list")
                        Text("プレイリスト")
                    }
                }
            FolderView()
                .tabItem {
                    VStack {
                        Image(systemName: "folder.fill")
                        Text("フォルダ")
                    }
                }
        }
        .accentColor(.accent)
        .sheet(isPresented: $viewDataStore.isShowPlayView, content: {
            PlayView()
        })
        .onAppear() {
            FileService.createDirectory(folderPath: "Playlist")
            FileService.createDirectory(folderPath: "Playlist/System")
            if !WillPlayRepository.isExistWillPlayM3U8() {
                guard WillPlayRepository.createWillPlayM3U8() else { return }
                print("succeeded")
            }
            if !PlayedRepository.isExistPlayedM3U8() {
                guard PlayedRepository.createPlayedM3U8() else { return }
                print("succeeded")
            }
            if !FavoriteMusicRepository.isExistFavoriteMusicM3U8() {
                guard FavoriteMusicRepository.createFavoriteMusicM3U8() else { return }
                print("succeeded")
            }
        }
    }
}
