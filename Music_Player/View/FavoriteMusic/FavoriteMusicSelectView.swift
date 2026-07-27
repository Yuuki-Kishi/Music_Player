//
//  FavoriteMusicSelectionMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/30.
//

import SwiftUI

struct FavoriteMusicSelectView: View {
    @StateObject var favoriteMusicDataStore = FavoriteMusicDataStore.shared
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
                if selectableMusicArray.isEmpty {
                    Spacer()
                    Text("表示できる曲がありません")
                    Spacer()
                } else {
                    List(selection: $selectionValue) {
                        ForEach(selectableMusicArray, id: \.self) { music in
                            FavoriteMusicSelectViewCell(music: music)
                        }
                    }
                    .environment(\.editMode, .constant(.active))
                    .listStyle(.plain)
                }
            }
        }
        .navigationTitle("追加する曲を選択")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .onAppear() {
            getSelectableMusics()
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
    func getSelectableMusics() {
        Task {
            selectableMusicArray = await FavoriteMusicRepository.getSelectableMusics()
            selectionValue = Set(selectableMusicArray.filter { isFavorite(filePath: $0.filePath) })
            isLoading = false
        }
    }
    func isFavorite(filePath: String) -> Bool {
        FavoriteMusicRepository.isFavoriteMusic(filePath: filePath)
    }
    func addMusic() {
        let musicFilePaths = selectionValue.map { $0.filePath }
        guard FavoriteMusicRepository.updateFavoriteMusics(newMusicFilePaths: musicFilePaths) else { return }
        pathDataStore.musicViewNavigationPath.removeLast()
    }
}

#Preview {
    FavoriteMusicView(favoriteMusicDataStore: FavoriteMusicDataStore.shared, playDataStore: PlayDataStore.shared, viewDataStore: ViewDataStore.shared, pathDataStore: PathDataStore.shared)
}
