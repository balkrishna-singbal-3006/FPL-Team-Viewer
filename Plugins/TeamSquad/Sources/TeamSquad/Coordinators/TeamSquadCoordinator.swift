//
//  TeamsSquadCoordinator.swift
//  TeamSquad
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//
import PluginAPIs
import UIKit

class TeamSquadCoordinator {
    private struct NavigationTitles {
        static let TeamSquadViewControllerTitle = "Squad"
    }
    
    // MARK:- Constants
    private let navigationController: UINavigationController
    private let squadPlayers: [SquadPlayer]
    
    init(squadPlayers: [SquadPlayer],
         navigationController: UINavigationController) {
        self.squadPlayers = squadPlayers
        self.navigationController = navigationController
    }
    
    /**
     Starts the coordinator.
     */
    func start() {
        print("squadPlayers = \(squadPlayers)")
        // 1. Create View Controller
        let viewController = TeamSquadViewController()
        viewController.title = NavigationTitles.TeamSquadViewControllerTitle
        
        // 2. Create View Model
        let viewModel = TeamSquadViewModel(coordinator: self)
        
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
