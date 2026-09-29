//
//  TeamsResponse.swift
//  TeamsList
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

import PluginAPIs

struct TeamsListResponse: Decodable {
    let teams: [Team]
    
    enum CodingKeys: String, CodingKey {
        case teams
        case players = "elements"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 1. Decode raw teams and players from the JSON root
        let rawTeams = try container.decode([RawTeam].self, forKey: .teams)
        let allPlayers = try container.decode([Player].self, forKey: .players)
        
        // 2. Group the players by their team ID for efficient lookup
        let playersByTeamId = Dictionary(grouping: allPlayers, by: { $0.teamId })
        
        // 3. Map the raw teams into your final Team models, injecting the matching players
        self.teams = rawTeams.map { rawTeam in
            let teamPlayers = playersByTeamId[rawTeam.id] ?? []
            return Team(
                name: rawTeam.name,
                shortName: rawTeam.shortName,
                players: teamPlayers
            )
        }
    }
}

private struct RawTeam: Decodable {
    let id: Int
    let name: String
    let shortName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortName = "short_name"
    }
}

struct Team {
    let name: String
    let shortName: String
    let players: [Player]
    
    var playerCount: Int {
        return players.count
    }
}

struct Player: Decodable {
    let id: Int
    let teamId: Int
    let firstName: String
    let lastName: String
    let totalPoints: Int
    let price: Int
    let position: Position
    
    enum Position: Int, Decodable {
        case goalkeeper = 1
        case defender = 2
        case midfielder = 3
        case forward = 4
        
        // Convenience computed property for UI display labels
        var shortName: String {
            switch self {
            case .goalkeeper: return "GKP"
            case .defender:   return "DEF"
            case .midfielder: return "MID"
            case .forward:    return "FWD"
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case teamId = "team"
        case firstName = "first_name"
        case lastName = "second_name"
        case totalPoints = "total_points"
        case price = "now_cost"
        case position = "element_type"
    }
}

extension Player {
    func toSquadPlayer() -> SquadPlayer {
        return SquadPlayer(id: id,
                           teamId: teamId,
                           firstName: firstName,
                           lastName: lastName,
                           totalPoints: totalPoints,
                           price: price)
    }
}
