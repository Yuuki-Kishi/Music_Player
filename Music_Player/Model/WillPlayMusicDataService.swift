//
//  WPMDService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/20.
//

import Foundation
import SwiftData

final class WillPlayMusicDataService {
    static let shared = WillPlayMusicDataService()
    lazy var actor = {
        return PersistanceActor(modelContainer: Persistance.sharedModelContainer)
    }()
    
    func createWillPlayMusicData(music: Music) async {
        let willPlayMusicData = WillPlayMusicData(musicName: music.musicName, artistName: music.artistName, albumName: music.albumName, editedDate: music.editedDate, fileSize: music.fileSize, musicLength: music.musicLength, filePath: music.filePath)
        await actor.insert(willPlayMusicData)
    }
    
    func deleteWillPlayMusicData(music: Music) async {
        let willPlayMusic = WillPlayMusicData(musicName: music.musicName, artistName: music.artistName, albumName: music.albumName, editedDate: music.editedDate, fileSize: music.fileSize, musicLength: music.musicLength, filePath: music.filePath)
        await actor.delete(willPlayMusic)
    }
    
    func getAllWillPlayMusicDatas() async -> [Music] {
        let predicate = #Predicate<WillPlayMusicData> { WillPlayMusicData in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        let willPlayMusicArray = await actor.get(descriptor) ?? []
        var musics = [Music]()
        for willPlayMusic in willPlayMusicArray {
            let music = Music(musicName: willPlayMusic.musicName, artistName: willPlayMusic.artistName, albumName: willPlayMusic.albumName, editedDate: willPlayMusic.editedDate, fileSize: willPlayMusic.fileSize, musicLength: willPlayMusic.musicLength, filePath: willPlayMusic.filePath)
            musics.append(music)
        }
        return musics
    }
}
