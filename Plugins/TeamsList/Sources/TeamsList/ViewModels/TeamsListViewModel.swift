//
//  TeamsListViewModel.swift
//  TeamsList
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

protocol TeamsViewModelRepresentable {
    var coordinator: TeamsListCoordinator? { get set }
    
    func fetchTeams() async throws -> [TeamViewModel]
    func teamCellTapped(for teamViewModel: TeamViewModel)
}

class TeamsListViewModel: TeamsViewModelRepresentable {
    weak var coordinator: TeamsListCoordinator?
    private var teams: [Team] = []
    
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
        self.teams = response.teams
        return self.teams.map({ TeamViewModel(from: $0) })
    }
    
    func teamCellTapped(for teamViewModel: TeamViewModel) {
        coordinator?.performAction(.showTeamSquad(players: teamViewModel.domainModel.players))
    }
}

struct TeamViewModel: Hashable {
    let title: String
    let subtitle: String
    let domainModel: Team // Pass-through reference to the domain model for action handling
    
    init(from domainModel: Team) {
        self.domainModel = domainModel
        self.title = domainModel.name
        self.subtitle = "\(domainModel.shortName.uppercased()) • \(domainModel.playerCount) Players"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(subtitle)
    }
    
    static func == (lhs: TeamViewModel, rhs: TeamViewModel) -> Bool {
        return lhs.title == rhs.title && lhs.subtitle == rhs.subtitle
    }
}
