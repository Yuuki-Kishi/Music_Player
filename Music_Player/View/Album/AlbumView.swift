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
    @Binding private var albumArray: [Album]
    
    init(mds: MusicDataStore, pc: PlayController, albumArray: Binding<[Album]>) {
        self.mds = mds
        self.pc = pc
        self._albumArray = albumArray
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
                List($albumArray) { album in
                    NavigationLink(value: album.albumName.wrappedValue, label: {
                        HStack {
                            Text(album.albumName.wrappedValue)
                            Spacer()
                            Text(String(album.musicCount.wrappedValue) + "曲")
                                .foregroundStyle(Color.gray)
                        }
                    })
                }
                .navigationDestination(for: String.self) { title in
                    AlbumMusicView(mds: mds, pc: pc, listMusicArray: $mds.listMusicArray, navigationTitle: title)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Menu {
                            Button(action: { mds.albumSort(method: .nameAscending) }, label: {
                                Text("アルバム名昇順")
                            })
                            Button(action: { mds.albumSort(method: .nameDescending) }, label: {
                                Text("アルバム名降順")
                            })
                            Button(action: { mds.albumSort(method: .countAscending) }, label: {
                                Text("曲数昇順")
                            })
                            Button(action: { mds.albumSort(method: .countDescending) }, label: {
                                Text("曲数降順")
                            })
                        } label: {
                            Image(systemName: "arrow.up.arrow.down.circle")
                        }
                    })
                }
                PlayingMusicView(pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
            }
            .navigationTitle("アルバム")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear() {
            mds.albumSelection()
        }
    }
}

