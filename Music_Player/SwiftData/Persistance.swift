//
//  Persistance.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/22.
//

import Foundation
import SwiftData

class Persistance {
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([PlaylistData.self, FavoriteMusicData.self, WillPlayMusicData.self, DidPlayMusicData.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("error create sharedModelContainer: \(error)")
        }
    }()
    
}

actor PersistanceActor: ModelActor {
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    func save() {
        do {
            try modelContext.save()
        }catch {
            print("error save")
        }
    }
    
    func insert<T:PersistentModel>(_ value:T) {
        do {
            modelContext.insert(value)
            try modelContext.save()
        } catch {
            print(error)
        }
    }
    
    func delete<T:PersistentModel>(_ value:T) {
        do {
            modelContext.delete(value)
            try modelContext.save()
        } catch {
            print(error)
        }
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
