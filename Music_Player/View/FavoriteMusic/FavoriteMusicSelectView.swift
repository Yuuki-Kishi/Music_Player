//
//  FavoriteMusicSelectMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/30.
//

import SwiftUI

struct FavoriteMusicSelectView: View {
    @EnvironmentObject private var favoriteMusicDataStore: FavoriteMusicDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    
    var body: some View {
        ZStack {
            BoolSwitchView(isEmpty: favoriteMusicDataStore.selectableMusicArray.isEmpty, isLoading: favoriteMusicDataStore.isLoading) {
                List(selection: $favoriteMusicDataStore.selectionValue) {
                    ForEach(favoriteMusicDataStore.selectableMusicArray, id: \.self) { music in
                        FavoriteMusicSelectViewCell(music: music)
                    }
                }
                .environment(\.editMode, .constant(.active))
                .listStyle(.plain)
            } emptyContent: {
                Text("FavoriteMusicSelectView.emptyContent.Text")
            }
        }
        .navigationTitle("FavoriteMusicSelectView.navigationTitle")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CheckMarkButton {
                    updateMusic()
                }
            }
        }
        .onAppear() {
            getSelectableMusics()
        }
    }
    func getSelectableMusics() {
        Task {
            favoriteMusicDataStore.isLoading = true
            favoriteMusicDataStore.selectableMusicArray = await FavoriteMusicRepository.getSelectableMusics()
            favoriteMusicDataStore.isLoading = false
        }
    }
    func updateMusic() {
        guard FavoriteMusicRepository.updateFavoriteMusics() else { return }
        print("updateSuccessed")
        pathDataStore.musicViewNavigationPath.removeLast()
    }
}

#Preview {
    FavoriteMusicSelectView()
}
