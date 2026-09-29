//
//  TeamsListViewModel.swift
//  TeamsList
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

protocol TeamsViewModelRepresentable {
    
  var coordinator: TeamsListCoordinator? { get set }
  
  func fetchTeams() async throws -> [TeamViewModel]
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
    
    func fetchTeams() async throws  -> [TeamViewModel] {
        let request = FetchTeamsListRequest()
        let response = try await request.execute()
        return response.teams.map({ TeamViewModel(from: $0) })
    }
}

struct TeamViewModel: Hashable {
    let title: String
    let subtitle: String
}

private extension TeamViewModel {
    init(from domainModel: Team) {
        self.title = domainModel.name
        self.subtitle = "\(domainModel.shortName.uppercased()) • \(domainModel.playerCount) Players"
    }
}
