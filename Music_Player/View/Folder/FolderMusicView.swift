//
//  FolderMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/06.
//

import SwiftUI

struct FolderMusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Binding var listMusicArray: [Music]
    @State var navigationTitle: String
    
    init(mds: MusicDataStore, pc: PlayController, listMusicArray: Binding<[Music]>, navigationTitle: String) {
        self.mds = mds
        self.pc = pc
        self._listMusicArray = listMusicArray
        _navigationTitle = State(initialValue: navigationTitle)
    }
    
    var body: some View {
        List($listMusicArray) { $folder in
            MusicCellView(mds: mds, pc: pc, music: folder)
        }
        .onAppear() {
            mds.collectFolderMusic(folder: navigationTitle)
        }
    }
}
