//
//  Playing.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI
import SwiftData

struct PlayView: View {
    @StateObject var favoriteMusicDataStore = FavoriteMusicDataStore.shared
    @StateObject var playDataStore = PlayDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    @State private var displaySeekPosition: TimeInterval = 0.0
    @State private var isEditingSeekPosition: Bool = false
    @State private var isShowAddPlaylist = false
    
    var body: some View {
        NavigationStack(path: $pathDataStore.playViewNavigationPath) {
            VStack {
                Spacer()
                Image(systemName: "music.note")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
                    .padding(100)
                    .foregroundStyle(Color(UIColor.systemGray))
                    .background(Color(UIColor.systemGray3))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                Spacer()
                HStack {
                    VStack {
                        Text(playDataStore.playingMusic?.musicName ?? "再生停止中")
                            .lineLimit(1)
                            .font(.system(size: 25).bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        Text(playDataStore.playingMusic?.artistName ?? "")
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
                Slider(value: $displaySeekPosition, in: 0 ... (playDataStore.playingMusic?.musicLength ?? 300), onEditingChanged: { isEditing in
                    isEditingSeekPosition = isEditing
                    if !isEditing {
                        
                    }
                })
                .onChange(of: playDataStore.seekPosition) {
                    if !isEditingSeekPosition {
                        self.displaySeekPosition = playDataStore.seekPosition
                    }
                }
                .tint(.purple)
                .padding(.horizontal)
                HStack {
                    Text(secToMin(sec: displaySeekPosition))
                        .font(.system(size: 12.5))
                        .foregroundStyle(.gray)
                    Spacer()
                    Text(secToMin(sec: displaySeekPosition - (playDataStore.playingMusic?.musicLength ?? 300)))
                        .font(.system(size: 12.5))
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: playModeImage())
                    })
                    .foregroundStyle(.purple)
                    Spacer()
                    Spacer()
                    Button(action: {
                        toggleFavorite()
                    }, label: {
                        Image(systemName: favoriteButtonImage())
                    })
                    .foregroundStyle(.purple)
                    Spacer()
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "list.bullet")
                    })
//                    NavigationLink(destination: WillPlayMusicView(mds: mds, pc: pc), label: {
//                        Image(systemName: "list.bullet")
//                    })
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
                        if playDataStore.isPlaying {
                            
                        } else {
                            
                        }
                    }, label: {
                        Image(systemName: playButtonImage())
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
                Spacer(minLength: 50)
            }
        }
        .navigationTitle("再生中の曲")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: PathDataStore.PlayViewPath.self) { path in
            switch path {
            case .addPlaylist:
                AddPlaylistView(music: playDataStore.playingMusic ?? Music(), pathArray: .play)
            case .musicInfo:
                MusicInfoView(music: playDataStore.playingMusic ?? Music())
            }
        }
        .padding()
        .onAppear() {
            displaySeekPosition = playDataStore.seekPosition
        }
    }
    func musicMenu() -> some View {
        Menu {
            Button(action: {
                pathDataStore.playViewNavigationPath.append(.addPlaylist)
            }, label: {
                Label("プレイリストに追加", systemImage: "text.badge.plus")
            })
            Button(action: {
                pathDataStore.playViewNavigationPath.append(.musicInfo)
            }, label: {
                Label("曲の情報", systemImage: "info.circle")
            })
            Divider()
            Button(action: {
                
            }, label: {
                Label("次に再生", systemImage: "text.line.first.and.arrowtriangle.forward")
            })
            Button(action: {
                
            }, label: {
                Label("最後に再生", systemImage: "text.line.last.and.arrowtriangle.forward")
            })
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.purple)
                .frame(width: 40, height: 40)
        }
        .menuOrder(.fixed)
//        .alert("設定完了", isPresented: $isShowAddFirstAlert, actions: {
//            Button("OK") { isShowAddFirstAlert = false }
//        }, message: {
//            Text("再生予定曲の先頭に追加しました。")
//        })
//        .alert("設定完了", isPresented: $isShowAddLastAlert, actions: {
//            Button("OK") { isShowAddLastAlert = false }
//        }, message: {
//            Text("再生予定曲の末尾に追加しました。")
//        })
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
        switch playDataStore.playMode {
        case .shuffle:
            return "shuffle"
        case .order:
            return "repeat"
        case .sameRepeat:
            return "repeat.1"
        }
    }
    func isFavorite() -> Bool {
        FavoriteMusicRepository.isFavoriteMusic(filePath: playDataStore.playingMusic?.filePath ?? "")
    }
    func toggleFavorite() {
        if isFavorite() {
            if FavoriteMusicRepository.toggleFavoriteMusic(filePath: playDataStore.playingMusic?.filePath ?? "") {
                favoriteMusicDataStore.favoriteMusicArray.remove(item: playDataStore.playingMusic ?? Music())
            }
        } else {
            if FavoriteMusicRepository.toggleFavoriteMusic(filePath: playDataStore.playingMusic?.filePath ?? "") {
                favoriteMusicDataStore.favoriteMusicArray.append(playDataStore.playingMusic ?? Music())
            }
        }
        
    }
    func favoriteButtonImage() -> String {
        if isFavorite() {
            return "heart.fill"
        } else {
            return "heart"
        }
    }
    func playButtonImage() -> String {
        if playDataStore.isPlaying {
            return "pause.fill"
        } else {
            return "play.fill"
        }
    }
}

#Preview {
    PlayView()
}
