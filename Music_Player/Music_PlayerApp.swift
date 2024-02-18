//
//  Music_PlayerApp.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

@main
struct Music_PlayerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(mds: MusicDataStore.shared, pc: PlayController.shared)
        }
    }
}
