//
//  TeamsListCoordinator.swift
//  TeamsList
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

import CoreComponents
import PluginAPIs
import UIKit

enum TeamsListAction: Actionable {
    case showTeamSquad(teamName: String,
                       players: [Player])
}

class TeamsListCoordinator: Coordinator {
    private struct NavigationTitles {
        static let TeamsListViewControllerTitle = "Teams List"
    }
    
    // MARK:- Constants
    let navigationController: UINavigationController
    private let teamSquadAPI: TeamSquadAPI
    
    // MARK:- Initializer
    init(navigationController: UINavigationController,
         teamSquadAPI: TeamSquadAPI) {
        self.navigationController = navigationController
        self.teamSquadAPI = teamSquadAPI
    }
    
    /**
     Starts the coordinator.
     */
    func start() {
        // 1. Create View Controller
        let viewController = TeamsListViewController()
        viewController.title = NavigationTitles.TeamsListViewControllerTitle
        
        // 2. Create View Model
        let viewModel = TeamsListViewModel(coordinator: self)
        
        // 3. Assign View Model and Push View Controller
        viewController.viewModel = viewModel
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func performAction(_ action: Actionable) {
        guard let teamsListAction = action as? TeamsListAction else {
            return
        }
        
        switch teamsListAction {
        case .showTeamSquad(let teamName, let players):
            navigateToTeamSquad(teamName: teamName,
                                players: players)
        }
    }
    
    private func navigateToTeamSquad(teamName: String,
                                     players: [Player]) {
        let squadPlayers = players.map({ $0.toSquadPlayer() })
        teamSquadAPI.showTeamSquadScreen(teamName: teamName,
                                          squadPlayers: squadPlayers,
                                          navigationController: navigationController)
    }
}
