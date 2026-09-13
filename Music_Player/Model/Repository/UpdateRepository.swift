//
//  UpdateRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/09/11.
//

import Foundation

@MainActor
class UpdateRepository {
    //check
    static func checkUpdate() async -> Bool {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return false }
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=6503210233") else { return false }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return false }
            guard let results = json["results"] as? [[String: Any]] else { return false }
            guard let latestVersion = results.first?["version"] as? String else { return false }
            return latestVersion.compare(currentVersion, options: .numeric) == .orderedDescending
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
