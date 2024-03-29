//
//  MusicCellView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/06.
//

import SwiftUI

struct MusicCellView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @State var music: Music
    @State private var isShowAlert = false
    @State private var deleteTarget: Music?
    
    init(mds: MusicDataStore, pc: PlayController, music: Music) {
        self.mds = mds
        self.pc = pc
        _music = State(initialValue: music)
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(music.musicName)
                    .lineLimit(1)
                    .font(.system(size: 20.0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(music.artistName!)
                        .lineLimit(1)
                        .font(.system(size: 12.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.gray)
                    Text(music.albumName!)
                        .lineLimit(1)
                        .font(.system(size: 12.5))
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundStyle(Color.gray)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                pc.stop()
                pc.setMusic(music: music)
                pc.setScheduleFile()
                pc.setNextMusics(playMode: .shuffle, musicArray: mds.musicArray)
                pc.isPlay = true
            }
            Spacer()
            Text(secToMin(second:music.musicLength!))
                .foregroundStyle(Color.gray)
            musicMenu(music: $music)
        }
    }
    func secToMin(second: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        if second < 3600 { dateFormatter.allowedUnits = [.minute, .second] }
        else { dateFormatter.allowedUnits = [.hour, .minute, .second] }
        dateFormatter.zeroFormattingBehavior = .pad
        return dateFormatter.string(from: second)!
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
                        await mds.fileDelete(filePath: deleteTarget.filePath)
                    }
                }
            }, label: {
                Text("削除")
            })
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
        }, message: {
                Text("この操作は取り消すことができません。この項目はゴミ箱に移動されます。")
        })
    }
    func testPrint() {
        print("OK")
    }
}
