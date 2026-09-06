//
//  PlayFlowView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/11.
//

import SwiftUI

struct PlayFlowView: View {
    @EnvironmentObject private var playFlowDataStore: PlayFlowDataStore
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                Section {
                    BoolSwitchView(isEmpty: playFlowDataStore.playBackMusicArray.isEmpty, isLoading: playFlowDataStore.isLoading) {
                        ForEach(playFlowDataStore.playBackMusicArray, id: \.filePath) { music in
                            PlayFlowViewCell(music: music, cellType: .playBuck)
                        }
                    } emptyContent: {
                        Text("PlayFlowView.List.PlayBackSection.emptyContent.Text")
                    }
                } header: {
                    Text("PlayFlowView.List.PlayBackSection.header.Text").id("PlayBack")
                }
                Section {
                    BoolSwitchView(isEmpty: playFlowDataStore.playNextMusicArray.isEmpty, isLoading: playFlowDataStore.isLoading) {
                        ForEach(playFlowDataStore.playNextMusicArray, id: \.filePath) { music in
                            PlayFlowViewCell(music: music, cellType: .playNext)
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete)
                    } emptyContent: {
                        Text("PlayFlowView.List.PlayNextSection.emptyContent.Text")
                    }
                } header: {
                    Text("PlayFlowView.List.PlayNextSection.header.Text").id("PlayNext")
                }
            }
            .onAppear() {
                getLists()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        proxy.scrollTo("PlayNext", anchor: .top)
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("PlayFlowView.NavigationTitle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        guard PlayFlowRepository.movePlayNextM3U8(from: source, to: destination) else { return }
        playFlowDataStore.playNextMusicArray.move(fromOffsets: source, toOffset: destination)
    }
    func delete(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let deleteMusic = playFlowDataStore.playNextMusicArray[index]
        guard PlayFlowRepository.removePlayNextM3U8(filePath: deleteMusic.filePath) else { return }
        playFlowDataStore.playNextMusicArray.remove(Music: deleteMusic)
    }
    func getLists() {
        Task {
            playFlowDataStore.isLoading = true
            playFlowDataStore.playNextMusicArray = await PlayFlowRepository.getPlayNextM3U8()
            playFlowDataStore.playBackMusicArray = await PlayFlowRepository.getPlayBackM3U8()
            playFlowDataStore.isLoading = false
        }
    }
}

#Preview {
    PlayFlowView()
}
