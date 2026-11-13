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
    @State private var selection = 0
    @State private var updateAlertIsPresented: Bool = false
    @Environment(\.openURL) private var openURL
    @Environment(\.tabViewBottomAccessoryPlacement) private var placement
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("ContentView.MusicView.Tab.Text", systemImage: "music.note", value: 0) {
                MusicView()
            }
            Tab("ContentView.ArtistView.Tab.Text", systemImage: "music.mic", value: 1) {
                ArtistView()
            }
            Tab("ContentView.AlbumView.Tab.Text", systemImage: "square.stack", value: 2) {
                AlbumView()
            }
            Tab("ContentView.PlaylistView.Tab.Text", systemImage: "music.note.list", value: 3) {
                PlaylistView()
            }
            Tab("ContentView.FolderView.Tab.Text", systemImage: "folder.fill", value: 4) {
                FolderView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewBottomAccessory {
            PlayWindowView()
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
            FileService.printDocumentDirectory()
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
