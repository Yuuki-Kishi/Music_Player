//
//  PlayList.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct PlaylistView: View {
    @ObservedObject var mdsvm: MusicDataStoreViewModel
    @ObservedObject var pcvm: PlayControllerViewModel
    @Binding private var plalistArray: [playlist]
    
    init(mdsvm: MusicDataStoreViewModel, pcvm: PlayControllerViewModel, playlistArray: Binding<[playlist]>) {
        self.mdsvm = mdsvm
        self.pcvm = pcvm
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
                    ListMusicView(mdsvm: mdsvm, pcvm: pcvm, navigationTitle: title, transitionSource: "playlist")
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.white)
                PlayingMusicView(pcvm: pcvm, musicName: $pcvm.musicName, artistName: $pcvm.artistName, albumName: $pcvm.albumName, seekPosition: $pcvm.seekPosition, isPlay: $pcvm.isPlay)
            }
            .navigationTitle("プレイリスト")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            
        }
    }
}
