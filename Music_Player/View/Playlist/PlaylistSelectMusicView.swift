//
//  SelectMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/18.
//

import SwiftUI
import SwiftData

struct PlaylistSelectMusicView: View {
    @EnvironmentObject private var playlistDataStore: PlaylistDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
        
    var body: some View {
        ZStack {
            BoolSwitchView(isEmpty: playlistDataStore.selectableMusicArray.isEmpty) {
                List(selection: $playlistDataStore.selectionValue) {
                    ForEach(playlistDataStore.selectableMusicArray, id: \.self) { music in
                        PlaylistSelectMusicViewCell(music: music)
                    }
                }
                .environment(\.editMode, .constant(.active))
                .listStyle(.plain)
            } emptyContent: {
                Text("PlaylistSelectMusicView.emptyContent.Text")
            }
        }
        .navigationTitle("PlaylistSelectMusicView.navigationTitle")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CheckMarkButton {
                    updateMusic()
                }
            }
        }
        .onAppear() {
            getSelectableMusicArray()
        }
    }
    func getSelectableMusicArray() {
        Task {
            playlistDataStore.isLoading = true
            playlistDataStore.selectableMusicArray = await MusicRepository.getMusics()
            playlistDataStore.selectionValue = includeMusics()
            playlistDataStore.isLoading = false
        }
    }
    func includeMusics() -> Set<Music> {
        let includeMusicFilePaths = PlaylistRepository.getIncludeMusicFilePaths()
        var includeMusics = Set<Music>()
        for filePath in includeMusicFilePaths {
            guard let music = playlistDataStore.selectableMusicArray.first(where: { $0.filePath == filePath }) else { continue }
            includeMusics.insert(music)
        }
        return includeMusics
    }
    func updateMusic() {
        guard PlaylistRepository.updatePlaylistMusics() else { return }
        print("updateSuccessed")
        pathDataStore.playlistViewNavigationPath.removeLast()
    }
}

#Preview {
    PlaylistSelectMusicView()
}
