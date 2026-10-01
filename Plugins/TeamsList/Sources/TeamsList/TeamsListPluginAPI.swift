// The Swift Programming Language
// https://docs.swift.org/swift-book

import CoreComponents
import PluginAPIs
import UIKit

public class TeamsListPluginAPI: TeamsListAPI {
    private let teamSquadAPI: TeamSquadAPI
    private var coordinator: Coordinator?
    
    public init(teamSquadAPI: TeamSquadAPI) {
        self.teamSquadAPI = teamSquadAPI
    }
    
    public func loadTeamsListScreen(navigationController: UINavigationController) {
        coordinator = TeamsListCoordinator(navigationController: navigationController,
                                           teamSquadAPI: self.teamSquadAPI)
        coordinator?.start()
    }
}
