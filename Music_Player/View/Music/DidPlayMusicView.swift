//
//  didPlayMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI
import SwiftData

struct DidPlayMusicView: View {
    @ObservedObject var mds: MusicDataStore
    @ObservedObject var pc: PlayController
    @Binding private var didPlayMusicArray: [Music]
    @State private var isShowDeleteAlert = false
    @State private var isShowNoDeleteAlert = false
    
    init(mds: MusicDataStore, pc: PlayController, didPlayMusicArray: Binding<[Music]>) {
        self.mds = mds
        self.pc = pc
        self._didPlayMusicArray = didPlayMusicArray
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(String(didPlayMusicArray.count) + "曲の再生履歴")
                Spacer()
            }
            .padding(.horizontal)
            List($didPlayMusicArray) { $didPlayMusic in
                MusicCellView(mds: mds, pc: pc, musics: didPlayMusicArray, music: didPlayMusic, playingView: .didPlay)
            }
            .listStyle(.plain)
            PlayingMusicView(mds: mds, pc: pc, music: $pc.music, seekPosition: $pc.seekPosition, isPlay: $pc.isPlay)
        }
        .onAppear() {
            if didPlayMusicArray.count > 100 {
                let deleteCount = didPlayMusicArray.count - 100
                for i in 0 ..< deleteCount {
                    didPlayMusicArray.removeFirst()
                }
            }
        }
        .navigationTitle("再生履歴")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    if didPlayMusicArray.isEmpty { isShowNoDeleteAlert = true }
                    else { isShowDeleteAlert = true }
                }, label: {
                    Image(systemName: "trash")
                        .foregroundStyle(Color.red)
                })
                .alert("削除できる項目がありません", isPresented: $isShowNoDeleteAlert, actions: {
                    Button(action: {}, label: {
                        Text("OK")
                    })
                })
                .alert("本当に削除しますか？", isPresented: $isShowDeleteAlert, actions: {
                    Button(role: .cancel, action: {}, label: {Text("キャンセル")})
                    Button(role: .destructive, action: {deleteAllMusics()}, label: {Text("削除")})
                }, message: {
                    Text("この操作を取り消すことはできません。")
                })
            })
        }
    }
    func deleteAllMusics() {
        Task {
            await DidPlayMusicDataService.shared.deleteAllDidPlayMusicDatas()
            didPlayMusicArray = await DidPlayMusicDataService.shared.readDidPlayMusics()
            isShowDeleteAlert = false
        }
    }
}
