//
//  listMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/28.
//

import SwiftUI

struct ListMusic: View {
    @ObservedObject var viewModel: ViewModel
    @Binding private var listMusicArray: [(musicName: String, artistName: String, albumName: String, belongDirectory: String)]
    @State var navigationTitle: String
    @State var transitionSource: String
    
    init(viewModel: ViewModel, listMusicArray: Binding<[(musicName: String, artistName: String, albumName: String, belongDirectory: String)]>, navigationTitle: String, transitionSource: String) {
        self.viewModel = viewModel
        self._listMusicArray = listMusicArray
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
            PlayingMusic(viewModel: viewModel, seekPosition: $viewModel.seekPosition, isPlay: $viewModel.isPlay, showSheet: $viewModel.showSheet)
        }
        .onAppear {
            switch transitionSource {
            case "Artist":
                viewModel.collectMusicOfArtist(artist: navigationTitle)
            case "Album":
                viewModel.collectMusicOfAlbum(album: navigationTitle)
            case "PlayList":
                viewModel.collectMusicOfPlayList(playList: navigationTitle)
            default:
                break
            }
        }
    }
    func testPrint() {
        print("敵影感知")
    }
}
