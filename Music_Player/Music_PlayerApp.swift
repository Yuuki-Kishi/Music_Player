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
            ContentView(mds: MusicDataStore.shared, pc: PlayController.shared)
                .modelContainer(for: [PlaylistData.self, FMD.self, DPMD.self])
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(.playback, mode: .default)
            }
            catch let e {
                print(e.localizedDescription)
            }
            return true
        }
        return true
    }
}
