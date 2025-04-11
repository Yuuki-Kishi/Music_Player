//
//  PlayFlowView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/11.
//

import SwiftUI

struct PlayFlowView: View {
    @StateObject var willPlayDataStore = WillPlayDataStore.shared
    @StateObject var playedDataStore = PlayedDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    @State private var isLoadingWillPlay: Bool = true
    @State private var isLoadingPlayed: Bool = true
    @Environment(\.editMode) var editMode
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                Section(header: Text("再生履歴").id("Played")) {
                    if isLoadingPlayed {
                        Text("読み込み中...")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        if playedDataStore.playedMusicArray.isEmpty {
                            Text("表示できる曲がありません")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ForEach(playedDataStore.playedMusicArray, id: \.self) { music in
                                PlayFlowViewPlayedCell(music: music)
                            }
                        }
                    }
                }
                Section(header: Text("再生予定").id("WillPlay")) {
                    if isLoadingWillPlay {
                        Text("読み込み中...")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        if willPlayDataStore.willPlayMusicArray.isEmpty {
                            Text("表示できる曲がありません")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ForEach(willPlayDataStore.willPlayMusicArray, id: \.self) { music in
                                PlayFlowViewWillPlayCell(music: music)
                                    .onTapGesture {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            withAnimation {
                                                proxy.scrollTo("WillPlay", anchor: .top)
                                            }
                                        }
                                    }
                            }
                            .onDelete(perform: delete)
                            .onMove(perform: move)
                        }
                    }
                }
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        proxy.scrollTo("WillPlay", anchor: .top)
                    }
                }
                getWillPlay()
                getPlayed()
            }
            .listStyle(.plain)
        }
        .navigationTitle("再生管理")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
    }
    func toolBarMenu() -> some View {
        Button(action: {
            withAnimation() {
                if editMode?.wrappedValue.isEditing == true {
                    editMode?.wrappedValue = .inactive
                } else {
                    editMode?.wrappedValue = .active
                }
            }
        }, label: {
            if editMode?.wrappedValue.isEditing == true {
                Text("完了")
                    .bold()
            } else {
                Text("編集")
            }
        })
    }
    func delete(at offsets: IndexSet) {
        let filePaths = offsets.map { willPlayDataStore.willPlayMusicArray[$0].filePath }
        guard WillPlayRepository.removeWillPlays(filePaths: filePaths) else { return }
        willPlayDataStore.willPlayMusicArray.remove(atOffsets: offsets)
    }
    func move(from source: IndexSet, to destination: Int) {
        guard WillPlayRepository.moveWillPlay(from: source, to: destination) else { return }
        willPlayDataStore.willPlayMusicArray.move(fromOffsets: source, toOffset: destination)
    }
    func getWillPlay() {
        Task {
            willPlayDataStore.willPlayMusicArray = await WillPlayRepository.getWillPlay()
            isLoadingWillPlay = false
        }
    }
    func getPlayed() {
        Task {
            playedDataStore.playedMusicArray = await PlayedRepository.getPlayed()
            isLoadingPlayed = false
        }
    }
}

#Preview {
    PlayFlowView()
}
