//
//  Music.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI
import SwiftData

struct MusicView: View {
    @EnvironmentObject private var musicDataStore: MusicDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationStack(path: $pathDataStore.musicViewNavigationPath) {
            VStack {
                BoolSwitchView(isEmpty: musicDataStore.musicArray.isEmpty, isLoading: musicDataStore.isLoading) {
                    RandomPlayButton(dataStore: .music)
                    List(musicDataStore.musicArray) { music in
                        MusicViewCell(music: music)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                } emptyContent: {
                    Text("MusicView.emptyContent.Text")
                }
                PlayWindowView()
            }
            .navigationTitle("MusicView.navigationTitle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathDataStore.MusicViewPath.self) { path in
                destination(path: path)
            }
            .sheet(isPresented: $musicDataStore.isShowAddPlaylistView) {
                AddPlaylistView(music: musicDataStore.musicArray.selected)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    toolBarMenu()
                }
            }
            .onAppear() {
                getMusics()
            }
        }
    }
    @ViewBuilder
    func destination(path: PathDataStore.MusicViewPath) -> some View {
        switch path {
        case .musicInfo:
//            MusicInfoView(playGroup: .music)
            MusicInfoView(music: musicDataStore.musicArray.selected)
        case .favoriteMusic:
            FavoriteMusicView()
        case .selectFavoriteMusic:
            FavoriteMusicSelectView()
        case .setting:
            SettingView()
        case .excludeFolderSelect:
            ExcludeFolderSelectView()
        case .equalizer:
            EqualizerView()
        case .sleepTimer:
            SleepTimerView()
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            ReloadButton {
                getMusics()
            }
            Button {
                pathDataStore.musicViewNavigationPath.append(.favoriteMusic)
            } label: {
                Label("MusicView.toolBarMenu.favoriteMusic.Label", systemImage: "star.fill")
            }
            Button {
                pathDataStore.musicViewNavigationPath.append(.setting)
            } label: {
                Label("MusicView.toolBarMenu.setting.Label", systemImage: "gear")
            }
            Menu {
                Button {
                    MusicRepository.sortAndUpdateMusicSortMode(sortMode: .nameAscending)
                } label: {
                    Text("MusicView.toolBarMenu.sort.nameAscending.Text")
                }
                Button {
                    MusicRepository.sortAndUpdateMusicSortMode(sortMode: .nameDescending)
                } label: {
                    Text("MusicView.toolBarMenu.sort.nameDescending.Text")
                }
                Button {
                    MusicRepository.sortAndUpdateMusicSortMode(sortMode: .dateAscending)
                } label: {
                    Text("MusicView.toolBarMenu.sort.dateAscending.Text")
                }
                Button(action: {
                    MusicRepository.sortAndUpdateMusicSortMode(sortMode: .dateDescending)
                }, label: {
                    Text("MusicView.toolBarMenu.sort.dateDescending.Text")
                })
            } label: {
                Label("MusicView.toolBarMenu.sort.Label", systemImage: "arrow.up.arrow.down")
            }
            Divider()
            Button {
                openSupportLink()
            } label: {
                Label("MusicView.toolBarMenu.Support.Text", systemImage: "arrow.up.right.square")
            }

        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    func getMusics() {
        Task {
            musicDataStore.isLoading = true
            musicDataStore.musicArray = await MusicRepository.getMusics()
            MusicRepository.sortMusicArray()
            musicDataStore.isLoading = false
        }
    }
    func openSupportLink() {
        let language = Bundle.main.preferredLocalizations.first ?? "en"
        switch language {
        case "en":
            openURL(URL(string: "https://forms.gle/VRUavfg9Jz7c5vw96")!)
        case "ja":
            openURL(URL(string: "https://forms.gle/UjQLPr86BDNgZUQRA")!)
        default:
            break
        }
    }
}

#Preview {
    MusicView()
}

