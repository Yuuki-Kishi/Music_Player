//
//  Playing.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI

struct PlayingView: View {
    @ObservedObject var pc: PlayController
    @Binding private var music: Music
    @Binding private var seekPosition: Double
    @Binding private var isPlay: Bool
    @State private var toMusicInfo = false
    @Environment(\.presentationMode) var presentation
    
    init(pc: PlayController, music: Binding<Music>, seekPosition: Binding<Double>, isPlay: Binding<Bool>) {
        self.pc = pc
        self._music = music
        self._seekPosition = seekPosition
        self._isPlay = isPlay
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    presentation.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.purple)
                        .font(.system(size: 25, weight: .semibold))
                })
                Spacer()
                Image(systemName: "music.note")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 300, height: UIScreen.main.bounds.width - 300)
                    .padding(100)
                    .foregroundStyle(Color(UIColor.systemGray))
                    .background(Color(UIColor.systemGray3))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                Spacer()
                HStack {
                    VStack {
                        Text("曲名")
                            .font(.system(size: 25).bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        Text("アーティスト名")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    Menu {
                        Button(role: .destructive, action: {testPrint()}) {
                            Label("ファイルを削除", systemImage: "trash")
                        }
                        Divider()
                        Button(action: {testPrint()}) {
                            Label("最後に再生", systemImage: "text.line.last.and.arrowtriangle.forward")
                        }
                        Button(action: {testPrint()}) {
                            Label("次に再生", systemImage: "text.line.first.and.arrowtriangle.forward")
                        }
                        Divider()
                        NavigationLink(destination: MusicInfoView(pc: pc, music: $pc.music), label: {
                            Label("曲の情報", systemImage: "info.circle")
                        })
                        Button(action: {testPrint()}) {
                            Label("ラブ", systemImage: "heart")
                        }
                        Button(action: {testPrint()}) {
                            Label("プレイリストに追加", systemImage: "text.badge.plus")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .frame(width: 40, height: 40)
                    }
                    .font(.system(size: 20, weight: .semibold))
                    .frame(width: 30, height: 30)
                    .background(Color(UIColor.systemGray5))
                    .foregroundStyle(.purple)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
                .padding(.horizontal)
                Spacer()
                Slider(value: $seekPosition)
                    .tint(.purple)
                    .padding(.horizontal)
                HStack {
                    Text(String(seekPosition))
                        .font(.system(size: 12.5))
                        .foregroundStyle(.gray)
                    Spacer()
                    Text(String(seekPosition - 1))
                        .font(.system(size: 12.5))
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "shuffle")
                    })
                    .foregroundStyle(.purple)
                    Spacer()
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "heart")
                    })
                    .foregroundStyle(.purple)
                    Spacer()
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "list.bullet")
                    })
                    .foregroundStyle(.purple)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "backward.fill")
                    })
                    .font(.system(size: 25.0))
                    .foregroundStyle(.primary)
                    Spacer()
                    Button(action: {
                        isPlay.toggle()
                    }, label: {
                        if isPlay {
                            Image(systemName: "pause.fill")
                        } else {
                            Image(systemName: "play.fill")
                        }
                    })
                    .font(.system(size: 40.0))
                    .foregroundStyle(.primary)
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "forward.fill")
                    })
                    .font(.system(size: 25.0))
                    .foregroundStyle(.primary)
                    Spacer()
                }
                Spacer()
            }.padding()
        }
    }
    func testPrint() {
        print("tapped")
    }
}
