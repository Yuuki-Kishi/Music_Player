//
//  Artist.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ArtistView: View {
    @ObservedObject var mdsvm: MusicDataStoreViewModel
    @ObservedObject var pcvm: PlayControllerViewModel
    @Binding private var musicArray: [Music]
    @State private var artistArray = [Artist]()
    
    init(mdsvm: MusicDataStoreViewModel, pcvm: PlayControllerViewModel, musicArray: Binding<[Music]>) {
        self.mdsvm = mdsvm
        self.pcvm = pcvm
        self._musicArray = musicArray
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(String(artistArray.count) + "人のアーティスト")
                        .lineLimit(1)
                        .font(.system(size: 15))
                        .frame(height: 20)
                    Spacer()
                }
                .padding(.horizontal)
                List {
                    ForEach(Array(artistArray.enumerated()), id: \.element.artistName) { index, artist in
                        let artistName = artist.artistName
                        let musicCount = artist.musicCount
                        NavigationLink(value: artistName, label: {
                            HStack {
                                Text(artistName)
                                Spacer()
                                Text(String(musicCount) + "曲")
                                    .foregroundStyle(Color.gray)
                            }
                        })
                    }
                }
                .navigationDestination(for: String.self) { title in
                    ListMusicView(mdsvm: mdsvm, pcvm: pcvm, navigationTitle: title, transitionSource: "Artist")
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                PlayingMusicView(pcvm: pcvm, musicName: $pcvm.musicName, artistName: $pcvm.artistName, albumName: $pcvm.albumName, seekPosition: $pcvm.seekPosition, isPlay: $pcvm.isPlay)
            }
            .navigationTitle("アーティスト")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear() {
            artistArray = mdsvm.artistSelection()
        }
    }
}
