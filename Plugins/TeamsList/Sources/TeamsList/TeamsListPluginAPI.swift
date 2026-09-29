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
        print("Inside showTeamsListScreen...")
        coordinator = TeamsListCoordinator(navigationController: navigationController)
        coordinator?.start()
    }
}
