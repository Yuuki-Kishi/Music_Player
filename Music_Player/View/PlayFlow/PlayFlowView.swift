//
//  PlayFlowView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/11.
//

import SwiftUI

struct PlayFlowView: View {
    @StateObject var playFlowDataStore = PlayFlowDataStore.shared
    @ObservedObject var playDataStore: PlayDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @Environment(\.editMode) var editMode
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                Section(header: Text("再生履歴").id("Played")) {
                    if playFlowDataStore.isLoading {
                        Text("読み込み中...")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        if playFlowDataStore.playedMusicArray.isEmpty {
                            Text("表示できる曲がありません")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ForEach(playFlowDataStore.playedMusicArray, id: \.self) { music in
                                PlayFlowViewPlayedCell(playFlowDataStore: playFlowDataStore, playDataStore: playDataStore, music: music)
                            }
                        }
                    }
                }
                Section(header: Text("再生予定").id("WillPlay")) {
                    if playFlowDataStore.isLoading {
                        Text("読み込み中...")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        if playFlowDataStore.willPlayMusicArray.isEmpty {
                            Text("表示できる曲がありません")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ForEach(playFlowDataStore.willPlayMusicArray, id: \.self) { music in
                                PlayFlowViewWillPlayCell(playFlowDataStore: playFlowDataStore, playDataStore: playDataStore, music: music)
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
                getLists()
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
        let filePaths = offsets.map { playFlowDataStore.willPlayMusicArray[$0].filePath }
        guard WillPlayRepository.removeWillPlays(filePaths: filePaths) else { return }
        playFlowDataStore.willPlayMusicArray.remove(atOffsets: offsets)
    }
    func move(from source: IndexSet, to destination: Int) {
        guard WillPlayRepository.moveWillPlay(from: source, to: destination) else { return }
        playFlowDataStore.willPlayMusicArray.move(fromOffsets: source, toOffset: destination)
    }
    func getLists() {
        Task {
            playFlowDataStore.willPlayMusicArray = await WillPlayRepository.getWillPlay()
            playFlowDataStore.playedMusicArray = await PlayedRepository.getPlayed()
            playFlowDataStore.isLoading = false
        }
    }
}

#Preview {
    PlayFlowView(playDataStore: PlayDataStore.shared, pathDataStore: PathDataStore.shared)
}
