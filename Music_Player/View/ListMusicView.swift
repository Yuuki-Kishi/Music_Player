//
//  listMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/28.
//

import SwiftUI

struct ListMusicView: View {
    @ObservedObject var mdsvm: MusicDataStoreViewModel
    @ObservedObject var pcvm: PlayControllerViewModel
    @State private var listMusicArray = [Music]()
    @State private var navigationTitle: String
    @State private var transitionSource: String
    
    init(mdsvm: MusicDataStoreViewModel, pcvm: PlayControllerViewModel, navigationTitle: String, transitionSource: String) {
        self.mdsvm = mdsvm
        self.pcvm = pcvm
        self.navigationTitle = navigationTitle
        self.transitionSource = transitionSource
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
            List {
                ForEach(Array(listMusicArray.enumerated()), id: \.element.musicName) { index, music in
                    let musicName = music.musicName
                    let artistName = music.artistName
                    let albumName = music.albumName
                    HStack {
                        VStack {
                            Text(musicName)
                                .lineLimit(1)
                                .font(.system(size: 20.0))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Text(artistName)
                                    .lineLimit(1)
                                    .font(.system(size: 12.5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(albumName)
                                    .lineLimit(1)
                                    .font(.system(size: 12.5))
                                    .frame(maxWidth: .infinity,alignment: .leading)
                            }
                        }
                        Spacer()
                        Menu {
                            Button(action: {testPrint()}) {
                                Label("プレイリストに追加", systemImage: "text.badge.plus")
                            }
                            Button(action: {testPrint()}) {
                                Label("ラブ", systemImage: "heart")
                            }
                            Button(action: {testPrint()}) {
                                Label("曲の情報", systemImage: "info.circle")
                            }
                            Divider()
                            Button(action: {testPrint()}) {
                                Label("次に再生", systemImage: "text.line.first.and.arrowtriangle.forward")
                            }
                            Button(action: {testPrint()}) {
                                Label("最後に再生", systemImage: "text.line.last.and.arrowtriangle.forward")
                            }
                            Divider()
                            Button(role: .destructive, action: {testPrint()}) {
                                Label("ファイルを削除", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(Color.primary)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            PlayingMusicView(pcvm: pcvm, musicName: $pcvm.musicName, artistName: $pcvm.artistName, albumName: $pcvm.albumName, seekPosition: $pcvm.seekPosition, isPlay: $pcvm.isPlay)
        }
        .onAppear {
            switch transitionSource {
            case "Artist":
                listMusicArray = mdsvm.collectArtistMusic(artist: navigationTitle)
            case "Album":
                listMusicArray = mdsvm.collectAlbumMusic(album: navigationTitle)
            case "playlist":
                Task { listMusicArray = await mdsvm.collectPlaylistMusic(playlistName: navigationTitle) }
            default:
                break
            }
        }
    }
    func testPrint() {
        print("敵影感知")
    }
}
