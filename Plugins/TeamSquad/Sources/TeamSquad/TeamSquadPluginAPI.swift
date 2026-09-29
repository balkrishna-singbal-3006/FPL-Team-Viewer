// The Swift Programming Language
// https://docs.swift.org/swift-book

import PluginAPIs
import UIKit

public class TeamsSquadPluginAPI: TeamSquadAPI {
    private var coordinator: TeamSquadCoordinator?
    
    public init() { }
    
    public func showTeamSquadScreen(navigationController: UINavigationController) {
        coordinator = TeamSquadCoordinator(navigationController: navigationController)
        coordinator?.start()
    }
}
