//
//  ArtistMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/24.
//

import SwiftUI

struct ArtistMusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Binding private var listMusicArray: [Music]
    @State private var navigationTitle: String
    @State private var isShowAlert = false
    @State private var deleteTarget: Music?
    @Environment(\.presentationMode) var presentation
    
    init(mds: MusicDataStore, pc: PlayController, listMusicArray: Binding<[Music]>, navigationTitle: String) {
        self.mds = mds
        self.pc = pc
        self._listMusicArray = listMusicArray
        _navigationTitle = State(initialValue: navigationTitle)
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: testPrint){
                        Image(systemName: "play.circle")
                            .foregroundStyle(.purple)
                        Text("すべて再生 " + String(listMusicArray.count) + "曲")
                        Spacer()
                    }
                    .foregroundStyle(.primary)
                    .padding(.horizontal)
                }
            }
            List($listMusicArray) { $music in
                let musicName = music.musicName
                let artistName = music.artistName
                let albumName = music.albumName
                HStack {
                    VStack {
                        Text(music.musicName)
                            .lineLimit(1)
                            .font(.system(size: 20.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text(artistName!)
                                .lineLimit(1)
                                .font(.system(size: 12.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(albumName!)
                                .lineLimit(1)
                                .font(.system(size: 12.5))
                                .frame(maxWidth: .infinity,alignment: .leading)
                        }
                    }
                    Spacer()
                    musicMenu(music: $music)
                }

            }
            .navigationTitle(navigationTitle)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            PlayingMusicView(pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
        }
        .onAppear() {
            mds.collectArtistMusic(artist: navigationTitle)
        }
    }
    func musicMenu(music: Binding<Music>) -> some View {
        Menu {
            Button(action: {testPrint()}) {
                Label("プレイリストに追加", systemImage: "text.badge.plus")
            }
            Button(action: {testPrint()}) {
                Label("ラブ", systemImage: "heart")
            }
            NavigationLink(destination: MusicInfoView(pc: pc, music: music), label: {
                Label("曲の情報", systemImage: "info.circle")
            })
            Divider()
            Button(action: {testPrint()}) {
                Label("次に再生", systemImage: "text.line.first.and.arrowtriangle.forward")
            }
            Button(action: {testPrint()}) {
                Label("最後に再生", systemImage: "text.line.last.and.arrowtriangle.forward")
            }
            Divider()
            Button(role: .destructive, action: {
                isShowAlert = true
                deleteTarget = music.wrappedValue
            }) {
                Label("ファイルを削除", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.primary)
                .frame(width: 40, height: 40)
        }
        .alert("本当に削除しますか？", isPresented: $isShowAlert, actions: {
            Button(role: .destructive, action: {
                if let deleteTarget {
                    Task {
                        await deleteFile(deleteTarget: deleteTarget)
                    }
                }
            }, label: {
                Text("削除")
            })
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
        }, message: {
            Text("この操作は取り消すことができません。")
        })
    }
    func deleteFile(deleteTarget: Music) async {
        await mds.fileDelete(filePath: deleteTarget.filePath)
        mds.collectArtistMusic(artist: navigationTitle)
        let index = mds.artistArray.firstIndex(where: {$0.artistName == navigationTitle})!
        mds.artistArray[index].musicCount -= 1
        if mds.artistArray[index].musicCount == 0 {
            mds.artistArray.remove(at: index)
            self.presentation.wrappedValue.dismiss()
        }
    }
    func testPrint() {
        print("敵影感知")
    }
}
