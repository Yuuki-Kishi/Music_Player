//
//  WillPlayMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI

struct WillPlayView: View {
    @StateObject var playDataStore = PlayDataStore.shared
    @StateObject var willPlayDataSotre = WillPlayDataStore.shared
    @State private var isLoading: Bool = true
    
    var body: some View {
        VStack {
            if isLoading {
                Spacer()
                Text("読み込み中...")
                Spacer()
            } else {
                if playDataStore.playMode == .sameRepeat {
                    Spacer()
                    Text("再生中の曲をリピートします")
                    Spacer()
                } else if willPlayDataSotre.willPlayMusicArray.isEmpty {
                    Spacer()
                    Text("表示できる曲がありません")
                    Spacer()
                } else {
                    List {
                        ForEach(willPlayDataSotre.willPlayMusicArray, id: \.filePath) { music in
                            WillPlayViewCell(music: music)
                        }
                        .onDelete(perform: delete)
                        .onMove(perform: move)
                    }
                    .listStyle(.plain)
                }
            }
        }
        .toolbar {
            MyEditButton()
        }
        .navigationTitle("再生予定曲")
        .onAppear() {
            getWillPlay()
        }
    }
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let filePath = willPlayDataSotre.willPlayMusicArray[offset].filePath
            if WillPlayRepository.removeWillPlay(filePaths: [filePath]) {
                willPlayDataSotre.willPlayMusicArray.remove(at: offset)
            }
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        if WillPlayRepository.moveWillPlay(from: source, to: destination) {
            willPlayDataSotre.willPlayMusicArray.move(fromOffsets: source, toOffset: destination)
        }
    }
    func getWillPlay() {
        Task {
            willPlayDataSotre.willPlayMusicArray = await WillPlayRepository.getWillPlay()
            isLoading = false
        }
    }
}

#Preview {
    WillPlayView()
}

struct MyEditButton: View {
    @Environment(\.editMode) var editMode
    
    var body: some View {
        Button(action: {
            withAnimation() {
                if editMode?.wrappedValue.isEditing == true {
                    editMode?.wrappedValue = .inactive
                } else {
                    editMode?.wrappedValue = .active
                }
            }
        }) {
            if editMode?.wrappedValue.isEditing == true {
                Text("完了")
            } else {
                Text("編集")
            }
        }
    }
}
