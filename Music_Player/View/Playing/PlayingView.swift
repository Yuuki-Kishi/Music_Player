//
//  Playing.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI
import SwiftData

struct PlayingView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Binding public var music: Music?
    @Binding private var seekPosition: TimeInterval
    @State private var seekPositionDisplay: TimeInterval = 0.0
    @State private var isEditingSeekPosition: Bool = false
    @Binding private var isPlay: Bool
    @Query private var FMArray: [FavoriteMusicData]
    @State private var toMusicInfo = false
    @State private var isFavorite = false
    @State private var isShowAddLastAlert = false
    @State private var isShowAddFirstAlert = false
    @Environment(\.modelContext) private var modelContext
    
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
                    musicMenu()
                    .font(.system(size: 20, weight: .semibold))
                    .frame(width: 30, height: 30)
                    .background(Color(UIColor.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
                .padding(.horizontal)
                Spacer()
                Slider(value: $seekPositionDisplay, in: 0 ... (music?.musicLength ?? 300), onEditingChanged: { isEditing in
                    isEditingSeekPosition = isEditing
                    if !isEditing {
                        pc.seekPosition = seekPositionDisplay
                        pc.setSeek()
                    }
                })
                .onChange(of: seekPosition) {
                    if !isEditingSeekPosition { self.seekPositionDisplay = seekPosition }
                }
                .tint(.purple)
                .padding(.horizontal)
                HStack {
                    Text(secToMin(sec: seekPositionDisplay))
                        .font(.system(size: 12.5))
                        .foregroundStyle(.gray)
                    Spacer()
                    Text(secToMin(sec: seekPositionDisplay - (music?.musicLength ?? 300)))
                        .font(.system(size: 12.5))
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {pc.changePlayMode()}, label: {
                        Image(systemName: playModeImage())
                    })
                    .foregroundStyle(.purple)
                    Spacer()
                    Spacer()
                    Button(action: { isFavoriteToggle() }, label: {
                        if isFavorite { Image(systemName: "heart.fill") }
                        else { Image(systemName: "heart")}
                    })
                    .foregroundStyle(.purple)
                    Spacer()
                    Spacer()
                    NavigationLink(destination: WillPlayMusicView(mds: mds, pc: pc), label: {
                        Image(systemName: "list.bullet")
                    })
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        pc.moveBeforeMusic()
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
                            pc.musicChoosed(music: mds.musicArray[Int.random(in: 0 ..< mds.musicArray.count)], musicArray: mds.musicArray, playingView: .music)
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
            }
            .navigationTitle("再生中の曲")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
        .onAppear() {
            isFavorite = FMArray.contains(where: {$0.musicName == music?.musicName!})
        }
    }
    func musicMenu() -> some View {
        Menu {
            NavigationLink(destination: AddPlaylistView(music: Binding(get: { music ?? Music() }, set: { music = $0 })), label: {
                Label("プレイリストに追加", systemImage: "text.badge.plus")
            })
            NavigationLink(destination: MusicInfoView(pc: pc, music: Binding(get: { music ?? Music() }, set: { music = $0 })), label: {
                Label("曲の情報", systemImage: "info.circle")
            })
            Divider()
            Button(action: {
                guard music != nil else { return }
                pc.addWPMFirst(music: music!)
                isShowAddFirstAlert = true
            }) {
                Label("次に再生", systemImage: "text.line.first.and.arrowtriangle.forward")
            }
            Button(action: {
                guard music != nil else { return }
                pc.addWPMLast(music: music!)
                isShowAddLastAlert = true
            }) {
                Label("最後に再生", systemImage: "text.line.last.and.arrowtriangle.forward")
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.purple)
                .frame(width: 40, height: 40)
        }
        .menuOrder(.fixed)
        .alert("設定完了", isPresented: $isShowAddFirstAlert, actions: {
            Button("OK") { isShowAddFirstAlert = false }
        }, message: {
            Text("再生予定曲の先頭に追加しました。")
        })
        .alert("設定完了", isPresented: $isShowAddLastAlert, actions: {
            Button("OK") { isShowAddLastAlert = false }
        }, message: {
            Text("再生予定曲の末尾に追加しました。")
        })
    }
    func secToMin(sec: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        if sec < 3600 { dateFormatter.allowedUnits = [.minute, .second] }
        else { dateFormatter.allowedUnits = [.hour, .minute, .second] }
        dateFormatter.zeroFormattingBehavior = .pad
        return dateFormatter.string(from: sec)!
    }
    func playModeImage() -> String {
        let playMode = pc.loadPlayMode()
        switch playMode {
        case .shuffle:
            return "shuffle"
        case .order:
            return "repeat"
        case .sameRepeat:
            return "repeat.1"
        }
    }
    func isFavoriteToggle() {
        if isFavorite {
            let item = FMArray.first(where: {$0.musicName == music?.musicName!})!
            modelContext.delete(item)
        } else { 
            let FavoriteMusicData = FavoriteMusicData(musicName: music?.musicName ?? "不明な曲", artistName: music?.artistName ?? "不明なアーティスト", albumName: music?.albumName ?? "不明なアルバム", editedDate: music?.editedDate ?? Date(), fileSize: music?.fileSize ?? "0MB", musicLength: music?.musicLength ?? 0, filePath: music?.filePath ?? "filePath")
            modelContext.insert(FavoriteMusicData)
        }
        isFavorite.toggle()
    }
    func testPrint() {
        print("tapped")
    }
}
