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
    @Binding private var artistArray: [Artist]
    
    init(mds: MusicDataStore, pc: PlayController, artistArray: Binding<[Artist]>) {
        self.mds = mds
        self.pc = pc
        self._artistArray = artistArray
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
                List($artistArray) { artist in
                    NavigationLink(value: artist.artistName.wrappedValue, label: {
                        HStack {
                            Text(artist.artistName.wrappedValue)
                            Spacer()
                            Text(String(artist.musicCount.wrappedValue) + "曲")
                                .foregroundStyle(Color.gray)
                        }
                    })
                    
                }
                .navigationDestination(for: String.self) { title in
                    ArtistMusicView(mds: mds, pc: pc, listMusicArray: $mds.listMusicArray, navigationTitle: title)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Menu {
                            Button(action: { mds.artistSort(method: .nameAscending) }, label: {
                                Text("アーティスト名昇順")
                            })
                            Button(action: { mds.artistSort(method: .nameDescending) }, label: {
                                Text("アーティスト名降順")
                            })
                            Button(action: { mds.artistSort(method: .countAscending) }, label: {
                                Text("曲数昇順")
                            })
                            Button(action: { mds.artistSort(method: .countDescending) }, label: {
                                Text("曲数降順")
                            })
                        } label: {
                            Image(systemName: "arrow.up.arrow.down.circle")
                        }
                    })
                }
                PlayingMusicView(pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
            }
            .navigationTitle("アーティスト")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear() {
            mds.artistSelection()
        }
    }
}
