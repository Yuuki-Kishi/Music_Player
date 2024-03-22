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
    @State private var playlistArray = [PlaylistData]()
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
                List($playlistArray) { $playlistData in
                    NavigationLink(value: playlistData, label: {
                        HStack {
                            Text(playlistData.playlistName)
                            Spacer()
                            Text(String(playlistData.musicCount) + "曲")
                                .foregroundStyle(Color.gray)
                        }
                    })
                }
                .navigationDestination(for: PlaylistData.self) { playlist in
                    PlaylistMusicView(mds: mds, pc: pc, listMusicArray: $mds.listMusicArray, playlistData: playlist)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                PlayingMusicView(mds: mds, pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
            }
            .navigationTitle("プレイリスト")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: { isShowAlert.toggle() }, label: {
                        Image(systemName: "plus")
                    })
                    .alert("プレイリストを作成する", isPresented: $isShowAlert, actions: {
                        TextField("プレイリスト名", text: $text)
                        Button("キャンセル", role: .cancel) {}
                        Button("作成") {
                            Task {
                                await PlaylistDataService.shared.createPlaylistData(playlistName: text)
                                getPlaylistArray()
                            }
                        }
                    }, message: {
                        Text("作成するプレイリストの名前を入力してください。")
                    })
                })
            }
            .onAppear() {
                getPlaylistArray()
            }
        }
    }
    func getPlaylistArray() {
        Task { playlistArray = await PlaylistDataService.shared.getAllFavoriteMusicDatas() }
    }
}
