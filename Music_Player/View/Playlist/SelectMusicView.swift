//
//  SelectMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/18.
//

import SwiftUI
import SwiftData

struct SelectMusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @State private var playlistData: PlaylistData
    @State private var selectionValue: Set<Music> = []
    @Environment(\.presentationMode) var presentation
    
    init(mds: MusicDataStore, pc: PlayController, playlistData: PlaylistData) {
        self.mds = mds
        self.pc = pc
        _playlistData = State(initialValue: playlistData)
    }
    
    var body: some View {
        VStack {
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
        var musics = [Music]()
        for music in selectionValue {
            musics.append(music)
        }
        await PlaylistDataService.shared.updatePlaylistData(playlistId: playlistData.playlistId, playlistName: playlistData.playlistName, musics: musics)
        presentation.wrappedValue.dismiss()
    }
}
