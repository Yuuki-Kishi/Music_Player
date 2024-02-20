//
//  Album.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct AlbumView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Binding private var musicArray: [Music]
    @State private var albumArray = [Album]()
    
    init(mds: MusicDataStore, pc: PlayController, musicArray: Binding<[Music]>) {
        self.mds = mds
        self.pc = pc
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
                    ListMusicView(mds: mds, pc: pc, navigationTitle: title, transitionSource: "Album")
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Menu {
                            Button(action: {albumArray.sort {$0.albumName < $1.albumName}}, label: {
                                Text("アルバム名昇順")
                            })
                            Button(action: {albumArray.sort {$0.albumName > $1.albumName}}, label: {
                                Text("アルバム名降順")
                            })
                            Button(action: {albumArray.sort {$0.musicCount < $1.musicCount}}, label: {
                                Text("曲数昇順")
                            })
                            Button(action: {albumArray.sort {$0.musicCount > $1.musicCount}}, label: {
                                Text("曲数降順")
                            })
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundStyle(Color.primary)
                        }
                    })
                }
                PlayingMusicView(pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
            }
            .navigationTitle("アルバム")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear() {
            albumArray = mds.albumSelection()
            albumArray.sort {$0.albumName < $1.albumName}
        }
    }
}
