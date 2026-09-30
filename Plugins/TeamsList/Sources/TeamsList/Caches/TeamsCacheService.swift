//
//  TeamsCacheService.swift
//  TeamsList
//
//  Created by Balkrishna Nitin Singbal on 9/30/26.
//

import Foundation

protocol TeamsCacheServiceRepresentable: Sendable {
    func saveTeams(_ teams: [Team]) async
    func loadTeams() async -> [Team]?
}

actor TeamsCacheService: TeamsCacheServiceRepresentable {
    private var cacheURL: URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("teams_cache.json")
    }
    
    // Using an Actor ensures thread-safe, non-blocking disk reads and writes
    func saveTeams(_ teams: [Team]) {
        do {
            let data = try JSONEncoder().encode(teams)
            try data.write(to: cacheURL, options: .atomic)
        } catch {
            print("## Cache Service Write Error: \(error.localizedDescription)")
        }
    }
    
    func loadTeams() -> [Team]? {
        guard FileManager.default.fileExists(atPath: cacheURL.path) else { return nil }
        do {
            let data = try Data(contentsOf: cacheURL)
            return try JSONDecoder().decode([Team].self, from: data)
        } catch {
            print("## Cache Service Read Error: \(error.localizedDescription)")
            return nil
        }
    }
}
