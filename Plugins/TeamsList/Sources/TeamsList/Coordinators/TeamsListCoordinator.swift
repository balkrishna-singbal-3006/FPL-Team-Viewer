//
//  TeamsListCoordinator.swift
//  TeamsList
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//
import PluginAPIs
import UIKit

class TeamsListCoordinator {
    private struct NavigationTitles {
        static let TeamsListViewControllerTitle = "Teams List"
    }
    
    enum Action {
        case showTeamSquad
    }
    
    // MARK:- Constants
    private let navigationController: UINavigationController
    private let teamSquadAPI: TeamSquadAPI?
    
    // MARK:- Initializer
    init(navigationController: UINavigationController,
         teamSquadAPI: TeamSquadAPI?) {
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
    
    /**
     Pops the view controller from the navigation stack.
     */
    func popBack() {
        self.navigationController.popViewController(animated: true)
    }
    
    func performAction(_ action: Action) {
        switch action {
        case .showTeamSquad:
            navigateToTeamSquad()
        }
    }
    
    private func navigateToTeamSquad() {
        teamSquadAPI?.showTeamSquadScreen(navigationController: navigationController)
    }
}
