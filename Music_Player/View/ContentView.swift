//
//  ContentView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var playDataStore = PlayDataStore.shared
    @StateObject var viewDataStore = ViewDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    
    var body: some View {
        TabView() {
            MusicView(playDataStore: playDataStore, viewDataStore: viewDataStore, pathDataStore: pathDataStore)
                .tabItem {
                    VStack {
                        Image(systemName: "music.note")
                        Text("ミュージック")
                    }
                }
            ArtistView(playDataStore: playDataStore, viewDataStore: viewDataStore, pathDataStore: pathDataStore)
                .tabItem {
                    VStack {
                        Image(systemName: "music.mic")
                        Text("アーティスト")
                    }
                }
                .navigationTitle("アーティスト")
            AlbumView(playDataStore: playDataStore, viewDataStore: viewDataStore, pathDataStore: pathDataStore)
                .tabItem {
                    VStack {
                        Image(systemName: "square.stack")
                        Text("アルバム")
                    }
                }
            PlaylistView(playDataStore: playDataStore, viewDataStore: viewDataStore, pathDataStore: pathDataStore)
                .tabItem {
                    VStack {
                        Image(systemName: "music.note.list")
                        Text("プレイリスト")
                    }
                }
            FolderView(playDataStore: playDataStore, viewDataStore: viewDataStore, pathDataStore: pathDataStore)
                .tabItem {
                    VStack {
                        Image(systemName: "folder.fill")
                        Text("フォルダ")
                    }
                }
        }
        .accentColor(.accent)
        .sheet(isPresented: $viewDataStore.isShowPlayView, onDismiss: {
            pathDataStore.playViewNavigationPath.removeAll()
        }, content: {
            PlayView(playDataStore: playDataStore, pathDataStore: pathDataStore)
        })
        .onAppear() {
            onAppear()
        }
    }
    func onAppear() {
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
