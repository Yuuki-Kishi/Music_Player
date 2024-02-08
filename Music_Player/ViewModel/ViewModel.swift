//
//  ViewModel.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/06.
//

import Foundation

@MainActor
class ViewModel: ObservableObject {
    @Published var model: FileService
    
    init(model: FileService) {
        self.model = model
    }
    
    var musicArray: [(musicName: String, artistName: String, albumName: String, belongDirectory: String)] {
        get {
            return model.musicArray
        }
        set {
            model.musicArray = newValue
        }
    }
    
    public func directoryCheck() {
        model.directoryCheck()
    }
}
