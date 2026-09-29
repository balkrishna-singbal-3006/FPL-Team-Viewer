// The Swift Programming Language
// https://docs.swift.org/swift-book

import PluginAPIs
import UIKit

public class TeamSquadPluginAPI: TeamSquadAPI {
    private var coordinator: TeamSquadCoordinator?
    
    public init() { }
    
    public func showTeamSquadScreen(squadPlayers: [SquadPlayer],
                                    navigationController: UINavigationController) {
        coordinator = TeamSquadCoordinator(squadPlayers: squadPlayers,
                                           navigationController: navigationController)
        coordinator?.start()
    }
}
