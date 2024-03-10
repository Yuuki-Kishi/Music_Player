//
//  Playing.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI

struct PlayingView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Binding public var music: Music?
    @Binding private var seekPosition: TimeInterval
    @Binding private var isPlay: Bool
    @State private var toMusicInfo = false
    @Environment(\.presentationMode) var presentation
    
    init(mds: MusicDataStore, pc: PlayController, music: Binding<Music?>, seekPosition: Binding<TimeInterval>, isPlay: Binding<Bool>) {
        self.mds = mds
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
                        Text(pc.music?.musicName ?? "再生停止中")
                            .lineLimit(1)
                            .font(.system(size: 25).bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        Text(pc.music?.artistName ?? "")
                            .lineLimit(1)
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    Menu {
                        Button(action: {testPrint()}) {
                            Label("プレイリストに追加", systemImage: "text.badge.plus")
                        }
                        Button(action: {testPrint()}) {
                            Label("ラブ", systemImage: "heart")
                        }
                        NavigationLink(destination: MusicInfoView(pc: pc, music: Binding(get: { music ?? Music() }, set: { music = $0 })), label: {
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
                        Button(role: .destructive, action: {testPrint()}) {
                            Label("ファイルを削除", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .frame(width: 40, height: 40)
                    }
                    .menuOrder(.fixed)
                    .font(.system(size: 20, weight: .semibold))
                    .frame(width: 30, height: 30)
                    .background(Color(UIColor.systemGray5))
                    .foregroundStyle(.purple)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
                .padding(.horizontal)
                Spacer()
                Slider(value: $seekPosition, in: 0 ... (music?.musicLength ?? 300))
                    .tint(.purple)
                    .padding(.horizontal)
                HStack {
                    Text(secToMin(sec: seekPosition))
                        .font(.system(size: 12.5))
                        .foregroundStyle(.gray)
                    Spacer()
                    Text(secToMin(sec: seekPosition - (music?.musicLength ?? 300)))
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
                        if music?.filePath != nil {
                            isPlay.toggle()
                        } else {
                            pc.musicChoosed(music: mds.musicArray[Int.random(in: 0 ..< mds.musicArray.count)], musicArray: mds.musicArray)
                        }
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
                        pc.moveNextMusic()
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
    func secToMin(sec: TimeInterval) -> String {
        //commit用
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        if sec < 3600 { dateFormatter.allowedUnits = [.minute, .second] }
        else { dateFormatter.allowedUnits = [.hour, .minute, .second] }
        dateFormatter.zeroFormattingBehavior = .pad
        return dateFormatter.string(from: sec)!
    }
    func testPrint() {
        print("tapped")
    }
}
