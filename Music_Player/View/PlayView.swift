//
//  Playing.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI
import SwiftData

struct PlayView: View {
    @StateObject var musicDataStore = MusicDataStore.shared
    @StateObject var favoriteMusicDataStore = FavoriteMusicDataStore.shared
    @ObservedObject var playDataStore: PlayDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var displaySeekPosition: TimeInterval = 0.0
    @State private var isEditingSeekPosition: Bool = false
    @State private var isShowAddPlaylist = false
    
    var body: some View {
        NavigationStack(path: $pathDataStore.playViewNavigationPath) {
            VStack {
                Spacer()
                coverImage()
                Spacer()
                HStack {
                    if playDataStore.playingMusic == nil {
                        VStack {
                            Spacer()
                            Text("再生停止中")
                                .font(.system(size: 25).bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                        }
                        .frame(height: 50)
                    } else {
                        VStack {
                            Text(playDataStore.playingMusic?.musicName ?? "不明な曲")
                                .lineLimit(1)
                                .font(.system(size: 25).bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(playDataStore.playingMusic?.artistName ?? "不明なアーティスト")
                                .lineLimit(1)
                                .font(.system(size: 20))
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(height: 50)
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
                        playDataStore.seekPosition = displaySeekPosition
                        playDataStore.setSeek()
                    }
                })
                .onChange(of: playDataStore.seekPosition) {
                    if !isEditingSeekPosition {
                        self.displaySeekPosition = playDataStore.seekPosition
                    }
                }
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
                        playDataStore.changePlayMode()
                    }, label: {
                        Image(systemName: playModeImage())
                    })
                    Spacer()
                    Spacer()
                    Button(action: {
                        toggleFavorite()
                    }, label: {
                        Image(systemName: favoriteButtonImage())
                    })
                    Spacer()
                    Spacer()
                    Button(action: {
                        pathDataStore.playViewNavigationPath.append(.playFlow)
                    }, label: {
                        Image(systemName: "list.bullet")
                    })
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        playDataStore.movePreviousMusic()
                    }, label: {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 25.0))
                            .foregroundStyle(.primary)
                    })
                    Spacer()
                    Button(action: {
                        if playDataStore.playingMusic == nil {
                            randomPlay()
                        } else {
                            if playDataStore.isPlaying {
                                playDataStore.pause()
                            } else {
                                playDataStore.play()
                            }
                        }
                    }, label: {
                        Image(systemName: playButtonImage())
                            .font(.system(size: 40.0))
                            .foregroundStyle(.primary)
                    })
                    Spacer()
                    Button(action: {
                        playDataStore.moveNextMusic()
                    }, label: {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 25.0))
                            .foregroundStyle(.primary)
                    })
                    Spacer()
                }
                Spacer(minLength: 50)
            }
            .navigationTitle("再生中の曲")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathDataStore.PlayViewPath.self) { path in
                destination(path: path)
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
                .frame(width: 40, height: 40)
        }
        .menuOrder(.fixed)
    }
    func coverImage() -> some View {
        if playDataStore.playingMusic?.coverImage.isEmpty == true || playDataStore.playingMusic == nil {
            return AnyView (
                Image(systemName: "music.note")
                    .scaledToFit()
                    .font(.system(size: UIScreen.main.bounds.height * 0.15))
                    .foregroundStyle(Color(UIColor.systemGray))
                    .frame(width: UIScreen.main.bounds.height * 0.3, height: UIScreen.main.bounds.height * 0.3)
                    .background(
                        RoundedRectangle(cornerRadius: UIScreen.main.bounds.height * 0.07)
                            .frame(width: UIScreen.main.bounds.height * 0.3, height: UIScreen.main.bounds.height * 0.3)
                            .foregroundStyle(Color(UIColor.systemGray4))
                    )
            )
        } else {
            return AnyView (
                Image(uiImage: UIImage(data: playDataStore.playingMusic?.coverImage ?? Data()) ?? UIImage())
                    .resizable()
                    .frame(width: UIScreen.main.bounds.height * 0.3, height: UIScreen.main.bounds.height * 0.3)
                    .clipShape(RoundedRectangle(cornerRadius: UIScreen.main.bounds.height * 0.07))
            )
        }
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
        guard let filePath = playDataStore.playingMusic?.filePath else { return false }
        return FavoriteMusicRepository.isFavoriteMusic(filePath: filePath)
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
    @ViewBuilder
    func destination(path: PathDataStore.PlayViewPath) -> some View {
        switch path {
        case .addPlaylist:
            AddPlaylistView(pathDataStore: pathDataStore, music: playDataStore.playingMusic ?? Music(), pathArray: .play)
        case .musicInfo:
            MusicInfoView(music: playDataStore.playingMusic ?? Music())
        case .playFlow:
            PlayFlowView(playDataStore: playDataStore, pathDataStore: pathDataStore)
        }
    }
    func randomPlay() {
        guard let music = musicDataStore.musicArray.randomElement() else { return }
        playDataStore.musicChoosed(music: music, playGroup: .music)
        playDataStore.setNextMusics(musicFilePaths: musicDataStore.musicArray.map { $0.filePath })
    }
}

#Preview {
    PlayView(playDataStore: PlayDataStore.shared, pathDataStore: PathDataStore.shared)
}
