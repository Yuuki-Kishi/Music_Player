//
//  UserDefaultsRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/10.
//

import Foundation

class UserDefaultsRepository {
    static let userDefaults = UserDefaults.standard
    
    //save
    static func savePlayMode(playMode: PlayDataStore.PlayMode) {
        print(playMode)
        userDefaults.set(playMode.rawValue, forKey: "PlayMode")
    }
    
    static func saveSortMode(sortMode: String, key: String) {
        userDefaults.set(sortMode, forKey: key)
    }
    
    static func savePlayingMusicFilePath(filePath: String) {
        userDefaults.set(filePath, forKey: "PlayingMusic")
    }
    
    //load
    static func loadPlayMode() -> PlayDataStore.PlayMode {
        guard let value = userDefaults.value(forKey: "PlayMode") as? String else { return .shuffle }
        print(value)
        guard let playMode = PlayDataStore.PlayMode(rawValue: value) else { return .shuffle }
        return playMode
    }
    
    static func loadSortMode(key: String) -> String? {
        guard let value = userDefaults.value(forKey: key) as? String else { return nil }
        return value
    }
    
    static func loadPlayingMusicFilePath() -> String? {
        guard let filePath = userDefaults.value(forKey: "PlayingMusic") as? String else { return nil }
        return filePath
    }
 }
