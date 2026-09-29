//
//  TeamsResponse.swift
//  TeamsList
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

struct TeamsListResponse: Decodable {
    let teams: [Team]
}

struct Team: Decodable {
    let name: String
    let shortName: String
    let playerCount = 0
    
    enum CodingKeys: String, CodingKey {
        case name
        case shortName = "short_name"
    }
}
