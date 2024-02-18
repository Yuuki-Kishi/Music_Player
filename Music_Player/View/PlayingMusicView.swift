//
//  playingMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI

struct PlayingMusicView: View {
    @ObservedObject var pc: PlayController
    @Binding private var musicName: String
    @Binding private var artistName: String
    @Binding private var albumName: String
    @Binding private var seekPosition: Double
    @Binding private var isPlay: Bool
    @State private var showSheet = false
    
    init(pc: PlayController, musicName: Binding<String>, artistName: Binding<String>, albumName: Binding<String>, seekPosition: Binding<Double>, isPlay: Binding<Bool>) {
        self.pc = pc
        self._musicName = musicName
        self._artistName = artistName
        self._albumName = albumName
        self._seekPosition = seekPosition
        self._isPlay = isPlay
    }
    
    var body: some View {
        ZStack {
            VStack {
                ProgressView(value: seekPosition, total: 1)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.purple))
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
                }
            }
            HStack(spacing: 0){
                Color.clear.contentShape(Rectangle())
                    .frame(maxWidth: .infinity, maxHeight: 20)
                    .padding()
                    .onTapGesture {
                        print("OK")
                        showSheet = !showSheet
                    }
                    .fullScreenCover(isPresented: $showSheet) {
                        PlayingView(pc: pc, musicName: $pc.musicName, artistName: $pc.artistName, albumName: $pc.albumName, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
                    }
                Button(action: {
                    isPlay = !isPlay
                }, label: {
                    if isPlay {
                        Image(systemName: "pause.fill")
                            .padding(14)
                    } else {
                        Image(systemName: "play.fill")
                            .padding(14)
                    }
                })
                .font(.system(size: 25.0))
                .foregroundStyle(.primary)
                Button(action: {
                    
                }){
                    Image(systemName: "forward.fill")
                        .padding(.vertical, 14)
                }
                .foregroundStyle(.primary)
                .font(.system(size: 25.0))
            }
        }
        .padding(.horizontal)
    }
}

