//
//  WillPlayMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI

struct WillPlayMusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    
    init(mds: MusicDataStore, pc: PlayController) {
        self.mds = mds
        self.pc = pc
    }
    
    var body: some View {
        List {
            ForEach($pc.willPlayMusics, id: \.self) { $music in
                MusicCellView(mds: mds, pc: pc, musics: pc.willPlayMusics, music: music, playingView: .willPlay)
            }
            .onDelete(perform: delete)
            .onMove(perform: move)
        }
        .toolbar {
            MyEditButton()
        }
        .listStyle(.plain)
        .navigationTitle("再生予定曲")
    }
    func delete(at offsets: IndexSet) {
        Task {
            pc.willPlayMusics.remove(atOffsets: offsets)
            await WillPlayMusicDataService.shared.resaveWillPlayMusicDatas(musics: pc.willPlayMusics)
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        Task {
            pc.willPlayMusics.move(fromOffsets: source, toOffset: destination)
            await WillPlayMusicDataService.shared.resaveWillPlayMusicDatas(musics: pc.willPlayMusics)
        }
    }
}

struct MyEditButton: View {
    @Environment(\.editMode) var editMode
    
    var body: some View {
        Button(action: {
            withAnimation() {
                if editMode?.wrappedValue.isEditing == true {
                    editMode?.wrappedValue = .inactive
                } else {
                    editMode?.wrappedValue = .active
                }
            }
        }) {
            if editMode?.wrappedValue.isEditing == true {
                Text("完了")
            } else {
                Text("編集")
            }
        }
    }
}
