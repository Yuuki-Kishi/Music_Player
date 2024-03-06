//
//  playingMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI

struct PlayingMusicView: View {
    @ObservedObject var pc: PlayController
    @Binding private var music: Music?
    @Binding private var seekPosition: Double
    @Binding private var isPlay: Bool
    @State private var showSheet = false
    
    init(pc: PlayController, music: Binding<Music?>, seekPosition: Binding<Double>, isPlay: Binding<Bool>) {
        self.pc = pc
        self._music = music
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
                        Text(music?.musicName ?? "再生停止中")
                            .lineLimit(1)
                            .font(.system(size: 20.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text(music?.artistName! ?? "")
                                .lineLimit(1)
                                .font(.system(size: 12.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(music?.albumName! ?? "")
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
                        showSheet.toggle()
                    }
                    .fullScreenCover(isPresented: $showSheet) {
                        PlayingView(pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
                    }
                Button(action: {
                    if music?.filePath != nil {
                        isPlay.toggle()
                    }
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

