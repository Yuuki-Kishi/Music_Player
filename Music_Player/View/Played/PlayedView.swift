//
//  didPlayMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI

struct PlayedView: View {
    @StateObject var playedDataStore = PlayedDataStore.shared
    @State private var isShowDeleteAlert = false
    @State private var isShowNoDeleteAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Text(String(playedDataStore.playedMusicArray.count) + "曲の再生履歴")
                Spacer()
            }
            .padding(.horizontal)
            List(playedDataStore.playedMusicArray) { music in
                PlayedViewCell(music: music)
            }
            .listStyle(.plain)
            PlayWindowView()
        }
        .onAppear() {
            
        }
        .navigationTitle("再生履歴")
    }
}

#Preview {
    PlayedView()
}
