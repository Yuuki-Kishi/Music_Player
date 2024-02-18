//
//  PlayList.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct PlaylistView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Binding private var plalistArray: [playlist]
    
    init(mds: MusicDataStore, pc: PlayController, playlistArray: Binding<[playlist]>) {
        self.mds = mds
        self.pc = pc
        self._plalistArray = playlistArray
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(String(plalistArray.count) + "個のプレイリスト")
                        .lineLimit(1)
                        .font(.system(size: 15))
                        .frame(height: 20)
                        .padding(.horizontal)
                    Spacer()
                }
                List {
                    ForEach(Array(plalistArray.enumerated()), id: \.element.playlistName) { index, playlist in
                        let playlistName = playlist.playlistName
                        NavigationLink(playlistName, value: playlistName)
                    }
                }
                .navigationDestination(for: String.self) { title in
                    ListMusicView(mds: mds, pc: pc, navigationTitle: title, transitionSource: "playlist")
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                PlayingMusicView(pc: pc, musicName: $pc.musicName, artistName: $pc.artistName, albumName: $pc.albumName, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
            }
            .navigationTitle("プレイリスト")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            
        }
    }
}
