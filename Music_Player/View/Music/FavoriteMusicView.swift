//
//  FavoriteMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI
import SwiftData

struct FavoriteMusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Environment(\.modelContext) private var modelContext
    @Query private var FMArray: [FMD]
    @Binding private var musicArray: [Music]
    @State private var listMusicArray = [Music]()
    
    init(mds: MusicDataStore, pc: PlayController, musicArray: Binding<[Music]>) {
        self.mds = mds
        self.pc = pc
        self._musicArray = musicArray
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(String(listMusicArray.count) + "曲のお気に入り")
                Spacer()
            }
            .padding(.horizontal)
            List($listMusicArray) { $music in
                MusicCellView(mds: mds, pc: pc, musicArray: $listMusicArray, music: music, playingView: .favorite)
            }
            .listStyle(.plain)
            .background(Color.clear)
            PlayingMusicView(mds: mds, pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
        }
        .navigationTitle("お気に入り")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {}, label: {
                    Image(systemName: "plus")
                })
            })
        }
        .onAppear() {
            for FMMusic in FMArray {
                if let music = musicArray.first(where: {$0.musicName == FMMusic.musicName}) {
                    listMusicArray.append(music)
                }
            }
        }
    }
}
