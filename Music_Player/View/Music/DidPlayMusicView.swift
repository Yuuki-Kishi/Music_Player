//
//  didPlayMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI
import SwiftData

struct DidPlayMusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @State private var didPlayMusicArray = [DidPlayMusicData]()
    @State private var listMusicArray = [Music]()
    
    init(mds: MusicDataStore, pc: PlayController) {
        self.mds = mds
        self.pc = pc
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(String(listMusicArray.count) + "曲の再生履歴")
                    .padding(.horizontal)
                Spacer()
            }
            List($listMusicArray) { $music in
                MusicCellView(mds: mds, pc: pc, musicArray: $listMusicArray, music: music, playingView: .didPlay)
            }
            .listStyle(.plain)
        }
        .navigationTitle("再生履歴")
        .onAppear() {
            Task {
                didPlayMusicArray = await DidPlayMusicDataService.shared.getAllDidPlayMusicDatas()
                for didPlayMusic in didPlayMusicArray {
                    let music = Music(musicName: didPlayMusic.musicName, artistName: didPlayMusic.artistName, albumName: didPlayMusic.albumName, editedDate: didPlayMusic.editedDate, fileSize: didPlayMusic.fileSize, musicLength: didPlayMusic.musicLength, filePath: didPlayMusic.filePath)
                    listMusicArray.append(music)
                }
            }
        }
    }
}
