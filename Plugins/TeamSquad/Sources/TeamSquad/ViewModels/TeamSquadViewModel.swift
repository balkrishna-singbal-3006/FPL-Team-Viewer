//
//  TeamSquadViewModel.swift
//  TeamSquad
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

import PluginAPIs

protocol TeamSquadViewModelRepresentable {
    var coordinator: TeamSquadCoordinator? { get set }
    var sections: [PositionSection] { get }
    var itemsPerSection: [PositionSection: [PlayerCellViewModel]] { get }
}

class TeamSquadViewModel: TeamSquadViewModelRepresentable {
    weak var coordinator: TeamSquadCoordinator?
    private let squadPlayers: [SquadPlayer]
    private(set) var sections: [PositionSection] = []
    private(set) var itemsPerSection: [PositionSection: [PlayerCellViewModel]] = [:]
    
    /**
      Initializes the TeamsListViewModel.
      - parameter coordinator: The coordinator instance.
      */
     init(coordinator: TeamSquadCoordinator,
          squadPlayers: [SquadPlayer]) {
         self.coordinator = coordinator
         self.squadPlayers = squadPlayers
         self.loadPlayers()
     }
    
    func loadPlayers() {
        let groupedDictionary = Dictionary(grouping: squadPlayers, by: { $0.position })
        let sortedPositions = groupedDictionary.keys.sorted()
        
        var updatedSections: [PositionSection] = []
        var updatedItems: [PositionSection: [PlayerCellViewModel]] = [:]

        for position in sortedPositions {
            let section = PositionSection(title: position.title)
            updatedSections.append(section)
            
            if let playersInPosition = groupedDictionary[position] {
                // Map Domain arrays directly into UI Cell ViewModels
                updatedItems[section] = playersInPosition.map { PlayerCellViewModel(from: $0) }
            }
        }
        
        // Update state and notify view layer
        self.sections = updatedSections
        self.itemsPerSection = updatedItems
    }
}

extension SquadPlayer.Position {
    var title: String {
        switch self {
        case .goalkeeper:
            return "Goalkeeper"
        case .defender:
            return "Defender"
        case .midfielder:
            return "Midfielder"
        case .forward:
            return "Forward"
        }
    }
}

// View Model for the row item (Keeps a reference to the domain payload)
struct PlayerCellViewModel: Hashable {
    let name: String
    let details: String
    
    init(from domainModel: SquadPlayer) {
        self.name = "\(domainModel.firstName) \(domainModel.lastName)"
        self.details = "£\(domainModel.price)m  •  \(domainModel.totalPoints) pts"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(details)
    }
    
    static func == (lhs: PlayerCellViewModel, rhs: PlayerCellViewModel) -> Bool {
        return lhs.name == rhs.name && lhs.details == rhs.details
    }
}

// Section structure mapping a Position Title to its array of View Models
struct PositionSection: Hashable {
    let title: String // e.g., "Defenders"
}
