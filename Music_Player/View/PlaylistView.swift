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
    @State private var toPlaylistMusicView = false
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
                        let musicCount = playlist.musicCount
                        let playlistId = playlist.playlistId
                        NavigationLink(value: playlist, label: {
                            HStack {
                                Text(playlistName)
                                Spacer()
                                Text(String(musicCount) + "曲")
                                    .foregroundStyle(Color.gray)
                            }
                        })
                    }
                }
                .navigationDestination(for: PlaylistData.self) { playlist in
                    PlaylistMusicView(mds: mds, pc: pc, navigationTitle: playlist.playlistName, playlistId: playlist.playlistId)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                PlayingMusicView(pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
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
                            text = ""
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
