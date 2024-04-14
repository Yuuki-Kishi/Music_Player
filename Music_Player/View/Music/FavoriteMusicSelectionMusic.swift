//
//  FavoriteMusicSelectionMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/30.
//

import SwiftUI

struct FavoriteMusicSelectionMusic: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @State private var selectionValue: Set<Music> = []
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        List(selection: $selectionValue) {
            ForEach($mds.musicArray, id: \.self) { $music in
                Text(music.musicName ?? "不明なミュージック")
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
    }
    func toolBarMenu() -> some View {
        HStack {
            Button(action: {
                if selectionValue.isEmpty {
                    selectionValue = Set(mds.musicArray)
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
                Task { await addMusics() }
            }, label: {
                Text("完了")
            })
        }
    }
    func addMusics() async {
        for value in selectionValue {
            await FavoriteMusicDataService.shared.createFavoriteMusicData(music: value)
        }
        presentation.wrappedValue.dismiss()
    }
}
