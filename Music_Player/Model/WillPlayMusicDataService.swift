//
//  WPMDService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/20.
//

import Foundation
import SwiftData

class WillPlayMusicDataPersistance {
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([WillPlayMusicData.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("error create sharedModelContainer: \(error)")
        }
    }()
    
}

actor WillPlayMusicDataPersistanceActor: ModelActor {
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    func insert<T:PersistentModel>(_ value:T) {
        modelContext.insert(value)
    }
    
    func delete<T:PersistentModel>(_ value:T) {
        modelContext.delete(value)
    }
    
    func get<T:PersistentModel>(_ descriptor:FetchDescriptor<T>)->[T]? {
        var fetched:[T]?
        do {
            fetched = try modelContext.fetch(descriptor)
        }catch {
            print("error get")
        }
        return fetched
    }
}

final class WillPlayMusicDataService {
    static let shared = WillPlayMusicDataService()
    lazy var actor = {
        return WillPlayMusicDataPersistanceActor(modelContainer: WillPlayMusicDataPersistance.sharedModelContainer)
    }()
    
    func createDPMD(music: Music) async {
        let WillPlayMusicData = WillPlayMusicData(musicName: music.musicName, artistName: music.artistName, albumName: music.albumName, editedDate: music.editedDate, fileSize: music.fileSize, musicLength: music.musicLength, filePath: music.filePath)
        await actor.insert(WillPlayMusicData)
    }
    
    func deleteDPMD(WillPlayMusicData: WillPlayMusicData) async {
        await actor.delete(WillPlayMusicData)
    }
    
    func getAllDPMDs() async -> [WillPlayMusicData] {
        let predicate = #Predicate<WillPlayMusicData> { WillPlayMusicData in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.get(descriptor) ?? []
    }
}
