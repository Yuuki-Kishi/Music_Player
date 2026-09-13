//
//  ContentView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var equalizerDataStore: EqualizerDataStore
    @EnvironmentObject private var playDataStore: PlayDataStore
    @State private var updateAlertIsPresented: Bool = false
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        TabView() {
            MusicView()
                .tabItem {
                    VStack {
                        Image(systemName: "music.note")
                        Text("ContentView.MusicView.tabItem.Text")
                    }
                }
            ArtistView()
                .tabItem {
                    VStack {
                        Image(systemName: "music.mic")
                        Text("ContentView.ArtistView.tabItem.Text")
                    }
                }
            AlbumView()
                .tabItem {
                    VStack {
                        Image(systemName: "square.stack")
                        Text("ContentView.AlbumView.tabItem.Text")
                    }
                }
            PlaylistView()
                .tabItem {
                    VStack {
                        Image(systemName: "music.note.list")
                        Text("ContentView.PlaylistView.tabItem.Text")
                    }
                }
            FolderView()
                .tabItem {
                    VStack {
                        Image(systemName: "folder.fill")
                        Text("ContentView.FolderView.tabItem.Text")
                    }
                }
        }
        .accentColor(.accent)
        .sheet(isPresented: $playDataStore.isShowPlayView) {
            PlayView()
        }
        .alert("ContentView.Alert.title", isPresented: $updateAlertIsPresented) {
            Button {
                openURL(URL(string: "https://itunes.apple.com/jp/app/apple-store/id6503210233")!)
            } label: {
                Text("ContentView.Alert.OpenButton.text")
            }
        } message: {
            Text("ContentView.Alert.message")
        }
        .onAppear() {
            onAppear()
        }
    }
    func onAppear() {
        Task {
            FileService.createDirectory(folderPath: "Playlist")
            FileService.createDirectory(folderPath: "System")
            if !ExcludeFolderRepository.isExistExcludeFolder() {
                if ExcludeFolderRepository.createExcludeFolder() {
                    print("succeeded")
                }
            }
            if !PlayFlowRepository.isExistPlayNextM3U8() {
                if PlayFlowRepository.createPlayNextM3U8() {
                    print("succeeded")
                }
            }
            if !PlayFlowRepository.isExistPlayBackM3U8() {
                if PlayFlowRepository.createPlayBackM3U8() {
                    print("succeeded")
                }
            }
            if FileService.isExist(path: "Playlist/System/Favorite.m3u8") {
                if FavoriteMusicRepository.migrationFavoriteMusic() {
                    print("migrateSucceeded")
                    if FileService.isExist(path: "Playlist/System") {
                        if FileService.fileDelete(filePath: "Playlist/System") {
                            print("fileDeleted")
                        }
                    }
                }
            }
            if !FavoriteMusicRepository.isExistFavoriteMusicM3U8() {
                if FavoriteMusicRepository.createFavoriteMusicM3U8() {
                    print("succeeded")
                }
            }
            if await EqualizerParameterRepository.isEmpty() {
                await EqualizerParameterRepository.createDefault()
            } else {
                equalizerDataStore.equalizerParameters = await EqualizerParameterRepository.getParameters()
                EqualizerParameterRepository.setEqualizer()
            }
            if let playingMusic = await PlayRepository.loadPlayingMusic() {
                PlayRepository.setMusic(music: playingMusic)
                PlayRepository.setScheduleFile()
                PlayRepository.setTimer()
            }
            if let isShuffle = UserDefaultsRepository.load(key: "isShuffle", as: Bool.self) {
                playDataStore.isShuffle = isShuffle
            }
            if let repeatModeString = UserDefaultsRepository.load(key: "repeatMode", as: String.self), let repeatMode = PlayDataStore.RepeatModeEnum(rawValue: repeatModeString) {
                playDataStore.repeatMode = repeatMode
            }
            if await UpdateRepository.checkUpdate() {
                updateAlertIsPresented = true
            }
        }
    }
}
