//
//  Artist.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ArtistView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Binding private var musicArray: [Music]
    @State private var artistArray = [Artist]()
    
    init(mds: MusicDataStore, pc: PlayController, musicArray: Binding<[Music]>) {
        self.mds = mds
        self.pc = pc
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
                    ListMusicView(mds: mds, pc: pc, navigationTitle: title, transitionSource: "Artist")
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Menu {
                            Button(action: {artistArray.sort {$0.artistName < $1.artistName}}, label: {
                                Text("アーティスト名昇順")
                            })
                            Button(action: {artistArray.sort {$0.artistName > $1.artistName}}, label: {
                                Text("アーティスト名降順")
                            })
                            Button(action: {artistArray.sort {$0.musicCount < $1.musicCount}}, label: {
                                Text("曲数昇順")
                            })
                            Button(action: {artistArray.sort {$0.musicCount > $1.musicCount}}, label: {
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
            .navigationTitle("アーティスト")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear() {
            artistArray = mds.artistSelection()
            artistArray.sort {$0.artistName < $1.artistName}
        }
    }
}
