//
//  TeamsListViewModel.swift
//  TeamsList
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

protocol TeamsViewModelRepresentable {
    
  var coordinator: TeamsListCoordinator? { get set }
  
  func fetchTeams()
}

class TeamsListViewModel: TeamsViewModelRepresentable {
    weak var coordinator: TeamsListCoordinator?
    
    /**
      Initializes the TeamsListViewModel.
      - parameter coordinator: The coordinator instance.
      */
     init(coordinator: TeamsListCoordinator) {
       self.coordinator = coordinator
     }
    
    func fetchTeams() {
        print("### Fetching teams...")
    }
}
