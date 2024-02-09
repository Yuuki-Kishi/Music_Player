//
//  playingMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI

struct PlayingMusic: View {
    @ObservedObject var viewModel: ViewModel
    @Binding private var seekPosition: Double
    @Binding private var isPlay: Bool
    @Binding private var showSheet: Bool
    
    init(viewModel: ViewModel, seekPosition: Binding<Double>, isPlay: Binding<Bool>, showSheet: Binding<Bool>) {
        self.viewModel = viewModel
        self._seekPosition = seekPosition
        self._isPlay = isPlay
        self._showSheet = showSheet
    }
    
    var body: some View {
        ZStack {
            VStack {
                ProgressView(value: seekPosition, total: 1)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.purple))
                HStack {
                    VStack {
                        Text("曲名")
                            .font(.system(size: 20.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text("アーティスト名")
                                .font(.system(size: 12.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("アルバム名")
                                .font(.system(size: 12.5))
                                .frame(maxWidth: .infinity,alignment: .leading)
                        }
                    }
                    Button(action: {
                        isPlay = !isPlay
                    }, label: {
                        if isPlay {
                            Image(systemName: "pause.fill")
                        } else {
                            Image(systemName: "play.fill")
                        }
                    })
                    .font(.system(size: 25.0))
                    .foregroundStyle(.primary)
                    Spacer(minLength: 30)
                    Button(action: {
                        
                    }){
                        Image(systemName: "forward.fill")
                    }
                    .foregroundStyle(.primary)
                    .font(.system(size: 25.0))
                }
            }
            Color.clear.contentShape(Rectangle())
            .frame(maxWidth: .infinity, maxHeight: 20)
            .padding()
            .onTapGesture {
                print("OK")
                showSheet = !showSheet
            }
            .fullScreenCover(isPresented: $showSheet) {
                Playing(seekPosition: $viewModel.seekPosition, isPlay: $viewModel.isPlay)
            }
        }
        .padding(.bottom)
    }
}

