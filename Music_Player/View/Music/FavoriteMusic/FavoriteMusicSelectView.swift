//
//  FavoriteMusicSelectionMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/30.
//

import SwiftUI

struct FavoriteMusicSelectView: View {
    @StateObject var favoriteMusicDataStore = FavoriteMusicDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    @State private var selectionValue: Set<Music> = []
    @State private var selectableMusicArray: [Music] = []
    
    var body: some View {
        List(selection: $selectionValue) {
            ForEach(selectableMusicArray, id: \.self) { music in
                FavoriteMusicViewCell(music: music)
            }
        }
        .environment(\.editMode, .constant(.active))
        .listStyle(.plain)
        .navigationTitle("追加する曲を選択")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .onAppear() {
            Task {
                selectableMusicArray = await FavoriteMusicRepository.getSelectableMusics()
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
                if !FavoriteMusicRepository.addFavoriteMusics(newMusicFilePaths: selectionValue.map { $0.filePath }) {
                    print("addFailed")
                }
            }, label: {
                Text("完了")
            })
        }
    }
}

#Preview {
    FavoriteMusicView()
}
