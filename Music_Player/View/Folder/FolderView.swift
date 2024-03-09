//
//  FolderView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/06.
//

import SwiftUI

struct FolderView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Binding private var folderArray: [Folder]
    @State private var toPlaylistMusicView = false
    
    init(mds: MusicDataStore, pc: PlayController, folderArray: Binding<[Folder]>) {
        self.mds = mds
        self.pc = pc
        self._folderArray = folderArray
    }
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(String(folderArray.count) + "個のフォルダ")
                        .lineLimit(1)
                        .font(.system(size: 15))
                        .frame(height: 20)
                        .padding(.horizontal)
                    Spacer()
                }
                List($folderArray) { folder in
                    NavigationLink(value: folder.folderName.wrappedValue, label: {
                        HStack {
                            Text(folder.folderName.wrappedValue)
                            Spacer()
                            Text(String(folder.musicCount.wrappedValue) + "曲")
                                .foregroundStyle(Color.gray)
                        }
                    })
                }
                .navigationDestination(for: String.self) { title in
                    FolderMusicView(mds: mds, pc: pc, listMusicArray: $mds.listMusicArray, navigationTitle: title)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                PlayingMusicView(pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
            }
            .navigationTitle("フォルダ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Menu {
                        Button(action: { mds.folderSort(method: .nameAscending) }, label: {
                            Text("フォルダ名昇順")
                        })
                        Button(action: { mds.folderSort(method: .nameDescending) }, label: {
                            Text("フォルダ名降順")
                        })
                        Button(action: { mds.folderSort(method: .countAscending) }, label: {
                            Text("曲数昇順")
                        })
                        Button(action: { mds.folderSort(method: .countDescending) }, label: {
                            Text("曲数降順")
                        })
                    } label: {
                        Label("並び替え", systemImage: "ellipsis.circle")
                    }
                })
            }
        }
    }
}
