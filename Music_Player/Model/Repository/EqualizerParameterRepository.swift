//
//  Eq.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/13.
//

import Foundation
import SwiftData

class EqualizerParameterRepository {
    static let actor = {
        return PersistanceActor(modelContainer: Persistance.sharedModelContainer)
    }()
    
    static func create(equalizerParameters: [EqualizerParameter]) async {
        for equalizerParameter in equalizerParameters {
            await actor.insert(equalizerParameter)
        }
    }
    
    static func read() async -> [EqualizerParameter] {
        let predicate = #Predicate<EqualizerParameter> { equalizerParameter in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        var equalizerParameters = await actor.get(descriptor) ?? []
        equalizerParameters.sort { $0.frequency < $1.frequency }
        return equalizerParameters
    }
    
    static func deleteAll() async {
        for equalizerParameter in await read() {
            await actor.delete(equalizerParameter)
        }
    }
}
