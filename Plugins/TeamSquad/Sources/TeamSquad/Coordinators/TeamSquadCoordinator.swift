//
//  TeamsSquadCoordinator.swift
//  TeamSquad
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//
import PluginAPIs
import UIKit

class TeamSquadCoordinator {
    // MARK:- Constants
    private let navigationController: UINavigationController
    private let squadPlayers: [SquadPlayer]
    private let teamName: String
    
    init(teamName: String,
         squadPlayers: [SquadPlayer],
         navigationController: UINavigationController) {
        self.teamName = teamName
        self.squadPlayers = squadPlayers
        self.navigationController = navigationController
    }
    
    /**
     Starts the coordinator.
     */
    func start() {
        // 1. Create View Controller
        let viewController = TeamSquadViewController()
        viewController.title = "\(teamName) Squad"
        
        // 2. Create View Model
        let viewModel = TeamSquadViewModel(coordinator: self,
                                           squadPlayers: squadPlayers)
        
        // 3. Assign View Model and Push View Controller
        viewController.viewModel = viewModel
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    /**
     Pops the view controller from the navigation stack.
     */
    func popBack() {
        self.navigationController.popViewController(animated: true)
    }
}
