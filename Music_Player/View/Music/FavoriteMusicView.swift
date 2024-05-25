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
    @State private var listMusicArray = [Music]()
    
    init(mds: MusicDataStore, pc: PlayController) {
        self.mds = mds
        self.pc = pc
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    if !listMusicArray.isEmpty {
                        pc.randomPlay(musics: listMusicArray)
                    }
                }){
                    Image(systemName: "play.circle")
                        .foregroundStyle(.purple)
                    Text("すべて再生 " + String(listMusicArray.count) + "曲")
                    Spacer()
                }
                .foregroundStyle(.primary)
            }
            .padding(.horizontal)
            List($listMusicArray) { $music in
                MusicCellView(mds: mds, pc: pc, musics: listMusicArray, music: music, playingView: .favorite)
            }
            .listStyle(.plain)
            .background(Color.clear)
            PlayingMusicView(mds: mds, pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
        }
        .navigationTitle("お気に入り")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                NavigationLink(destination: FavoriteMusicSelectionMusic(mds: mds, pc: pc), label: {
                    Image(systemName: "plus")
                })
            })
        }
        .onAppear() {
            deleteImaginaryFavoriteMusic()
        }
    }
    func deleteImaginaryFavoriteMusic() {
        Task {
            listMusicArray = await FavoriteMusicDataService.shared.readFavoriteMusics()
            var listMusics = [Music]()
            for listMusic in listMusicArray {
                if pc.checkImaginaryMusics(music: listMusic) {
                    listMusics.append(listMusic)
                }
            }
            await FavoriteMusicDataService.shared.deleteAllFavoriteMusicData()
            for i in 0 ..< listMusics.count {
                let item = listMusics[i]
                await FavoriteMusicDataService.shared.createFavoriteMusicData(music: item)
            }
            listMusicArray = await FavoriteMusicDataService.shared.readFavoriteMusics()
            listMusicArray.sort {$0.musicName ?? "不明" < $1.musicName ?? "不明"}
        }
    }
}
