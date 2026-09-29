//
//  TeamSquadViewModel.swift
//  TeamSquad
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

protocol TeamSquadViewModelRepresentable {
    var coordinator: TeamSquadCoordinator? { get set }
}

class TeamSquadViewModel: TeamSquadViewModelRepresentable {
    weak var coordinator: TeamSquadCoordinator?
    
    /**
      Initializes the TeamsListViewModel.
      - parameter coordinator: The coordinator instance.
      */
     init(coordinator: TeamSquadCoordinator) {
       self.coordinator = coordinator
     }
}
