//
//  Playing.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI
import SwiftData

struct PlayView: View {
    @EnvironmentObject private var playDataStore: PlayDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    
    var body: some View {
        NavigationStack(path: $pathDataStore.playViewNavigationPath) {
            GeometryReader { geometry in
                VStack {
                    CoverImageView(geometry: geometry)
                    Spacer()
                    MusicNameView()
                    Spacer()
                    SliderView()
                    OperationView()
                    Spacer()
                    VolumeSliderView()
                        .frame(height: 30)
                        .padding()
                    PlayModeView()
                    Spacer()
                }
            }
            .navigationTitle("PlayView.navigationTitle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathDataStore.PlayViewPath.self) { path in
                destination(path: path)
            }
            .sheet(isPresented: $playDataStore.isShowAddPlaylistView) {
                AddPlaylistView(music: playDataStore.playingMusic)
            }
        }
    }
    @ViewBuilder
    func destination(path: PathDataStore.PlayViewPath) -> some View {
        switch path {
        case .musicInfo:
//            MusicInfoView(playGroup: .play)
            MusicInfoView(music: playDataStore.playingMusic)
        case .playFlow:
            PlayFlowView()
        }
    }
}

#Preview {
    PlayView()
        .environmentObject(PlayDataStore.shared)
        .environmentObject(PathDataStore.shared)
}
