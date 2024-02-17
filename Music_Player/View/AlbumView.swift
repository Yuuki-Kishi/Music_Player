//
//  Album.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct AlbumView: View {
    @ObservedObject var mdsvm: MusicDataStoreViewModel
    @ObservedObject var pcvm: PlayControllerViewModel
    @Binding private var musicArray: [Music]
    @State private var albumArray = [Album]()
    
    init(mdsvm: MusicDataStoreViewModel, pcvm: PlayControllerViewModel, musicArray: Binding<[Music]>) {
        self.mdsvm = mdsvm
        self.pcvm = pcvm
        self._musicArray = musicArray
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(String(albumArray.count) + "枚のアルバム")
                        .lineLimit(1)
                        .font(.system(size: 15))
                        .frame(height: 20)
                        .padding(.horizontal)
                    Spacer()
                }
                List {
                    ForEach(Array(albumArray.enumerated()), id: \.element.albumName) { index, album in
                        let albumName = album.albumName
                        let musicCount = album.musicCount
                        NavigationLink(value: albumName, label: {
                            HStack {
                                Text(albumName)
                                Spacer()
                                Text(String(musicCount) + "曲")
                                    .foregroundStyle(Color.gray)
                            }
                        })
                    }
                }
                .navigationDestination(for: String.self) { title in
                    ListMusicView(mdsvm: mdsvm, pcvm: pcvm, navigationTitle: title, transitionSource: "Album")
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                PlayingMusicView(pcvm: pcvm, musicName: $pcvm.musicName, artistName: $pcvm.artistName, albumName: $pcvm.albumName, seekPosition: $pcvm.seekPosition, isPlay: $pcvm.isPlay)
            }
            .navigationTitle("アルバム")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear() {
            albumArray = mdsvm.albumSelection()
        }
    }
}
