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
    
    init(mds: MusicDataStore, pc: PlayController) {
        self.mds = mds
        self.pc = pc
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(String(didPlayMusicArray.count) + "曲の再生履歴")
                    .padding(.horizontal)
                Spacer()
            }
            List($didPlayMusicArray) { $didPlayMusic in
                MusicCellView(mds: mds, pc: pc, musics: convertToMusics(didPlayMusicArray: didPlayMusicArray), music: convertToMusic(didPlayMusic: didPlayMusic), playingView: .didPlay)
            }
            .listStyle(.plain)
            PlayingMusicView(mds: mds, pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
        }
        .navigationTitle("再生履歴")
        .onAppear() {
            Task {
                didPlayMusicArray = await DidPlayMusicDataService.shared.getAllDidPlayMusicDatas()
            }
        }
    }
    func convertToMusic(didPlayMusic: DidPlayMusicData) -> Music {
        let music = Music(musicName: didPlayMusic.musicName, artistName: didPlayMusic.artistName, albumName: didPlayMusic.albumName, editedDate: didPlayMusic.editedDate, fileSize: didPlayMusic.fileSize, musicLength: didPlayMusic.musicLength, filePath: didPlayMusic.filePath)
        return music
    }
    func convertToMusics(didPlayMusicArray: [DidPlayMusicData]) -> [Music] {
        var musics = [Music]()
        for didPlayMusic in didPlayMusicArray {
            let music = Music(musicName: didPlayMusic.musicName, artistName: didPlayMusic.artistName, albumName: didPlayMusic.albumName, editedDate: didPlayMusic.editedDate, fileSize: didPlayMusic.fileSize, musicLength: didPlayMusic.musicLength, filePath: didPlayMusic.filePath)
            musics.append(music)
        }
        return musics
    }
}
