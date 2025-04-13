//
//  SelectMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/18.
//

import SwiftUI
import SwiftData

struct PlaylistSelectMusicView: View {
    @ObservedObject var playlistDataStore: PlaylistDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var selectionValue: Set<Music> = []
    @State private var selectableMusicArray: [Music] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            if isLoading {
                Spacer()
                Text("読み込み中...")
                Spacer()
            } else {
                List(selection: $selectionValue) {
                    ForEach(selectableMusicArray, id: \.self) { music in
                        PlaylistSelectMusicViewCell(music: music)
                    }
                }
                .environment(\.editMode, .constant(.active))
                .listStyle(.plain)
            }
        }
        .navigationTitle("追加する曲を選択")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .onAppear() {
            getSelectableMusicArray()
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
                addMusic()
            }, label: {
                Text("完了")
            })
        }
    }
    func getSelectableMusicArray() {
        Task {
            selectableMusicArray = await MusicRepository.getMusics()
            sortSelectableMusicArray()
            selectionValue = Set(selectableMusicArray.filter { isInclude(musicFilePath: $0.filePath) })
            isLoading = false
        }
    }
    func sortSelectableMusicArray() {
        switch playlistDataStore.playlistMusicSortMode {
        case .nameAscending:
            selectableMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            selectableMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            selectableMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            selectableMusicArray.sort { $0.editedDate > $1.editedDate }
        }
    }
    func isInclude(musicFilePath: String) -> Bool {
        guard let playlistFilePath = playlistDataStore.selectedPlaylist?.filePath else { return false }
        return PlaylistRepository.isIncludeMusic(playlistFilePath: playlistFilePath, musicFilePath: musicFilePath)
    }
    func addMusic() {
        guard let filePath = playlistDataStore.selectedPlaylist?.filePath else { return }
        let musicFilePaths = selectionValue.map { $0.filePath }
        guard PlaylistRepository.updatePlaylistMusics(playlistFilePath: filePath, musicFilePaths: musicFilePaths) else { return }
        pathDataStore.playlistViewNavigationPath.removeLast()
    }
}

#Preview {
    PlaylistSelectMusicView(playlistDataStore: PlaylistDataStore.shared, pathDataStore: PathDataStore.shared)
}
