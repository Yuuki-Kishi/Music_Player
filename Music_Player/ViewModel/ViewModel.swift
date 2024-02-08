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
    
    var musicArray: Array<(music: String, artist: String, album: String, belong: String)> {
        get {
            return model.musicArray
        }
        set {
            model.musicArray = newValue
        }
    }
    
    public func fileImport() {
        model.fileImport()
    }
}
