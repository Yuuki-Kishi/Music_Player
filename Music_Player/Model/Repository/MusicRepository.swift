//
//  MusicRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/03/29.
//

import Foundation

@MainActor
class MusicRepository {
    //create
    
    //check
    
    //get
    static func getMusics() async -> [Music] {
        let fileURLs = FileService.getFileURLs()
        var musics: [Music] = []
        for fileURL in fileURLs {
            let music = await FileService.getFileMetadata(filePath: fileURL.path())
            musics.append(music)
        }
        MusicDataStore.shared.arraySort(mode: MusicDataStore.shared.musicsSortMode)
        return musics
    }
    
    //update
    
    //delete
    static func fileDelete(music: Music) {
        if FileService.fileDelete(filePath: music.filePath) {
            MusicDataStore.shared.musicArray.remove(item: music)
        }
    }
}
