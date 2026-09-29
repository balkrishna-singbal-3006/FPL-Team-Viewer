//
//  TeamSquadAPI.swift
//  PluginAPIs
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

import UIKit

public protocol TeamSquadAPI {
    func showTeamSquadScreen(squadPlayers: [SquadPlayer],
                             navigationController: UINavigationController)
}

public struct SquadPlayer {
    public let id: Int
    public let teamId: Int
    public let firstName: String
    public let lastName: String
    public let totalPoints: Int
    public let price: Int
    
    public init(id: Int, teamId: Int, firstName: String, lastName: String, totalPoints: Int, price: Int) {
        self.id = id
        self.teamId = teamId
        self.firstName = firstName
        self.lastName = lastName
        self.totalPoints = totalPoints
        self.price = price
    }
}
