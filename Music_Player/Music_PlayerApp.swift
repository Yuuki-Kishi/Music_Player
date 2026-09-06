//
//  Music_PlayerApp.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI
import SwiftData
import AVFoundation

@main
struct Music_PlayerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AddPlaylistDataStore.shared)
                .environmentObject(AlbumDataStore.shared)
                .environmentObject(ArtistDataStore.shared)
                .environmentObject(EqualizerDataStore.shared)
                .environmentObject(ExcludeFolderDataStore.shared)
                .environmentObject(FavoriteMusicDataStore.shared)
                .environmentObject(FolderDataStore.shared)
                .environmentObject(MusicDataStore.shared)
                .environmentObject(PathDataStore.shared)
                .environmentObject(PlayDataStore.shared)
                .environmentObject(PlayFlowDataStore.shared)
                .environmentObject(PlaylistDataStore.shared)
                .environmentObject(TimerDataStore.shared)
        }
        .modelContainer(Persistance.sharedModelContainer)
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
        }
        catch let error {
            print(error.localizedDescription)
        }
        return true
    }
}
