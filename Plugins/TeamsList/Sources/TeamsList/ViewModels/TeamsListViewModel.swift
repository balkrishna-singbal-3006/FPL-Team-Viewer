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
    private let cacheService: TeamsCacheServiceRepresentable
    
    /**
      Initializes the TeamsListViewModel.
      - parameter coordinator: The coordinator instance.
      */
     init(coordinator: TeamsListCoordinator,
          cacheService: TeamsCacheServiceRepresentable = TeamsCacheService()) {
       self.coordinator = coordinator
         self.cacheService = cacheService
     }
    
    func fetchTeams() async throws  -> [TeamViewModel] {
        let request = FetchTeamsListRequest()
        do {
            // 1. Fetch remote data
            let response = try await request.execute()
            self.teams = response.teams
            
            // 2. Offload serialization and writing safely to the standalone service
            await cacheService.saveTeams(response.teams)
            
            return self.teams.map({ TeamViewModel(from: $0) })
        } catch {
            // 3. Fallback to the standalone cache entity upon network failure
            if let cachedTeams = await cacheService.loadTeams() {
                self.teams = cachedTeams
                print("## Cache hit! Displaying offline data.")
                return self.teams.map({ TeamViewModel(from: $0) })
            }
            
            // Neither network nor cache worked; throw error up to UI
            throw error
        }
    }
    
    func teamCellTapped(for teamViewModel: TeamViewModel) {
        coordinator?.performAction(TeamsListAction.showTeamSquad(teamName: teamViewModel.domainModel.name,
                                                                 players: teamViewModel.domainModel.players))
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
