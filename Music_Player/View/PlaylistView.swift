//
//  PlayList.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI
import SwiftData

struct PlaylistView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Query private var playlistArray: [PlaylistData]
    @State private var isShowAlert = false
    @State private var text = ""
    
    init(mds: MusicDataStore, pc: PlayController) {
        self.mds = mds
        self.pc = pc
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(String(playlistArray.count) + "個のプレイリスト")
                        .lineLimit(1)
                        .font(.system(size: 15))
                        .frame(height: 20)
                        .padding(.horizontal)
                    Spacer()
                }
                List {
                    ForEach(Array(playlistArray.enumerated()), id: \.element.playlistName) { index, playlist in
                        let playlistName = playlist.playlistName
                        NavigationLink(playlistName, value: playlistName)
                    }
                }
                .navigationDestination(for: String.self) { title in
                    let index = playlistArray.firstIndex(where: {$0.playlistName == title})!
                    let playlistId = playlistArray[index].playlistId
                    PlaylistMusicView(mds: mds, pc: pc, navigationTitle: title, playlistId: playlistId)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                PlayingMusicView(pc: pc, musicName: $pc.musicName, artistName: $pc.artistName, albumName: $pc.albumName, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
            }
            .navigationTitle("プレイリスト")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: { isShowAlert.toggle() }, label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.primary)
                    })
                    .alert("プレイリストを作成する", isPresented: $isShowAlert, actions: {
                        TextField("プレイリスト名", text: $text)
                            
                        Button("キャンセル", role: .cancel) {}
                        Button("作成") {
                            let playlist = PlaylistData(playlistName: text)
                            modelContext.insert(playlist)
                        }
                    }, message: {
                        Text("作成するプレイリストの名前を入力してください。")
                    })
                })
            }
        }
        .onAppear {
            
        }
    }
}
