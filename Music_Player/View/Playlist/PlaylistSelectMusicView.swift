//
//  SelectMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/18.
//

import SwiftUI
import SwiftData

struct PlaylistSelectMusicView: View {
    @StateObject var playlistDataStore = PlaylistDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    @State private var selectionValue: Set<Music> = []
    @State private var selectableMusicArray: [Music] = []
    
    var body: some View {
        List(selection: $selectionValue) {
            ForEach(selectableMusicArray, id: \.filePath) { music in
                PlaylistSelectMusicViewCell(music: music)
            }
            .environment(\.editMode, .constant(.active))
        }
        .frame(maxHeight: .infinity)
        .listStyle(.plain)
        .navigationTitle("追加する曲を選択")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .onAppear() {
            Task {
                selectableMusicArray = await MusicRepository.getMusics()
            }
        }
    }
    func toolBarMenu() -> some View {
        HStack {
            Button(action: {
                if selectionValue.isEmpty {
                    selectionValue = Set(selectableMusicArray)
                } else {
                    selectionValue = []
                }
            }, label: {
                if selectionValue.isEmpty {
                    Text("全て選択")
                } else {
                    Text("全て解除")
                }
            })
            Button(action: {
                Task {
                    if await PlaylistRepository.addPlaylistMusics(playlist: playlistDataStore.selectedPlaylist ?? Playlist(), musicFilePaths: selectionValue.map { $0.filePath }) {
                        print("success")
                    }
                    pathDataStore.playlistViewNavigationPath.removeLast()
                }
            }, label: {
                Text("完了")
            })
        }
    }
}

#Preview {
    PlaylistSelectMusicView()
}
