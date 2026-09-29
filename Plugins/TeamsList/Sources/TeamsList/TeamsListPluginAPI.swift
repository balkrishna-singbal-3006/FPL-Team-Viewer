// The Swift Programming Language
// https://docs.swift.org/swift-book

import PluginAPIs
import UIKit

public class TeamsListPluginAPI: TeamsListAPI {
    private let teamSquadAPI: TeamSquadAPI
    private var coordinator: TeamsListCoordinator?
    
    public init(teamSquadAPI: TeamSquadAPI) {
        self.teamSquadAPI = teamSquadAPI
    }
    
    public func showTeamsListScreen(navigationController: UINavigationController) {
        coordinator = TeamsListCoordinator(navigationController: navigationController,
                                           teamSquadAPI: self.teamSquadAPI)
        coordinator?.start()
    }
}
