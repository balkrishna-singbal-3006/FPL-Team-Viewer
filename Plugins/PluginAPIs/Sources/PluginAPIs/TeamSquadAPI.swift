//
//  TeamSquadAPI.swift
//  PluginAPIs
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

import UIKit

public protocol TeamSquadAPI {
    func showTeamSquadScreen(teamName: String,
                             squadPlayers: [SquadPlayer],
                             navigationController: UINavigationController)
}

public struct SquadPlayer {
    public enum Position: Int, Comparable, Hashable {
        case goalkeeper = 1
        case defender = 2
        case midfielder = 3
        case forward = 4
        
        public static func < (lhs: Position, rhs: Position) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
    
    public let id: Int
    public let teamId: Int
    public let firstName: String
    public let lastName: String
    public let totalPoints: Int
    public let price: Int
    public let position: Position
    
    public init(id: Int, teamId: Int, firstName: String, lastName: String, totalPoints: Int, price: Int, position: Position) {
        self.id = id
        self.teamId = teamId
        self.firstName = firstName
        self.lastName = lastName
        self.totalPoints = totalPoints
        self.price = price
        self.position = position
    }
}
