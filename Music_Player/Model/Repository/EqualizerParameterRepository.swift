//
//  Eq.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/13.
//

import Foundation
import SwiftData

@MainActor
class EqualizerParameterRepository {
    static let equalizerDataStore: EqualizerDataStore = .shared
    static let playDataStore: PlayDataStore = .shared
    static let actor = {
        return PersistanceActor(modelContainer: Persistance.sharedModelContainer)
    }()
    
    //create
    static func createDefault() async {
        for frequency in equalizerDataStore.frequencys {
            let equalizerParameter = EqualizerParameter(type: 0, bandWidth: 1.0, frequency: frequency, gain: 0.0)
            await actor.insert(equalizerParameter)
        }
    }
    
    static func insert() async {
        for equalizerParameter in equalizerDataStore.equalizerParameters {
            await actor.insert(equalizerParameter)
        }
    }
    
    //get
    static func getParameters() async -> [EqualizerParameter] {
        let predicate = #Predicate<EqualizerParameter> { equalizerParameter in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        var equalizerParameters = await actor.get(descriptor) ?? []
        equalizerParameters.sort { $0.frequency < $1.frequency }
        return equalizerParameters
    }
    
    static func isEmpty() async -> Bool {
        let predicate = #Predicate<EqualizerParameter> { equalizerParameter in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.getCount(descriptor) == 0 ? true : false
    }
    
    //update
    static func save() async {
        await actor.save()
    }
    
    static func setEqualizer() {
        playDataStore.equalizerNode.bypass = false
        playDataStore.equalizerNode.bands.enumerated().forEach { index, parameter in
            parameter.filterType = .parametric
            parameter.bypass = false
            parameter.bandwidth = equalizerDataStore.equalizerParameters[index].bandWidth
            parameter.frequency = equalizerDataStore.equalizerParameters[index].frequency
            parameter.gain = equalizerDataStore.equalizerParameters[index].gain
        }
    }
    
    //delete
    static func deleteAll() async {
        for equalizerParameter in await getParameters() {
            await actor.delete(equalizerParameter)
        }
    }
}
