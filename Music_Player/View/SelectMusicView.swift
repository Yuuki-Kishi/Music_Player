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
    @Query private var playlistArray: [PlaylistData]
    @Binding private var musicArray: [Music]
    @State private var selectionValue: Set<Music> = []
    @State private var playlistId: String
    @Environment(\.presentationMode) var presentation
    
    init(mds: MusicDataStore, pc: PlayController, musicArray: Binding<[Music]>, playlistId: String) {
        self.mds = mds
        self.pc = pc
        self._musicArray = musicArray
        _playlistId = State(initialValue: playlistId)
    }
    
    var body: some View {
        VStack {
            List(selection: $selectionValue) {
                ForEach(musicArray, id: \.self) { music in
                    Text(music.musicName)
                }
            }
            .environment(\.editMode, .constant(.active))
            .listStyle(.plain)
            .navigationTitle("追加する曲を選択")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    HStack {
                        Button(action: {
                            if selectionValue.isEmpty {
                                selectionValue = Set(musicArray)
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
                            let index = playlistArray.firstIndex(where: {$0.playlistId == playlistId})!
                            let newValue = playlistArray[index].musics + Array(selectionValue)
                            playlistArray[index].musics = newValue
                            self.presentation.wrappedValue.dismiss()
                        }, label: {
                            Text("完了")
                        })
                    }
                })
            }
        }
    }
}
