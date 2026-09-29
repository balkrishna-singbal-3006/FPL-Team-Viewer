//
//  TeamsListCoordinator.swift
//  TeamsList
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//
import UIKit

class TeamsListCoordinator {
    struct NavigationTitles {
        static let TeamsListViewControllerTitle = "Teams List"
    }
    
    // MARK:- Constants
    let navigationController: UINavigationController
    
    // MARK:- Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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
}
