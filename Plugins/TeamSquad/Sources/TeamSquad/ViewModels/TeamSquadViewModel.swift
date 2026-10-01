//
//  TeamSquadViewModel.swift
//  TeamSquad
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//
import CoreComponents
import PluginAPIs

protocol TeamSquadViewModelRepresentable {
    var coordinator: Coordinator { get }
    var sections: [PositionSection] { get }
    var itemsPerSection: [PositionSection: [PlayerCellViewModel]] { get }
    func updateSortType(to newSort: SortCriteria)
}

enum SortCriteria {
    case totalPoints
    case price
}

class TeamSquadViewModel: TeamSquadViewModelRepresentable {
    let coordinator: Coordinator
    private let squadPlayers: [SquadPlayer]
    private(set) var sections: [PositionSection] = []
    private(set) var itemsPerSection: [PositionSection: [PlayerCellViewModel]] = [:]
    private(set) var currentSort: SortCriteria = .totalPoints
    
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
    
    func updateSortType(to newSort: SortCriteria) {
        guard self.currentSort != newSort else { return }
        
        self.currentSort = newSort
        self.sortPlayers()
    }
    
    private func loadPlayers() {
        let groupedDictionary = Dictionary(grouping: squadPlayers, by: { $0.position })
        let sortedPositions = groupedDictionary.keys.sorted()
        
        var updatedSections: [PositionSection] = []
        var updatedItems: [PositionSection: [PlayerCellViewModel]] = [:]

        for position in sortedPositions {
            let section = PositionSection(title: position.title)
            updatedSections.append(section)
            
            if let playersInPosition = groupedDictionary[position] {
                // Initial generation pass maps raw items flat into View Models
                updatedItems[section] = playersInPosition.map { PlayerCellViewModel(from: $0) }
            }
        }
        
        self.sections = updatedSections
        self.itemsPerSection = updatedItems
        
        // Apply sorting criteria configuration baseline
        self.sortPlayers()
    }
    
    private func sortPlayers() {
        for (section, viewModels) in itemsPerSection {
            itemsPerSection[section] = viewModels.sorted(by: { left, right in
                switch currentSort {
                case .totalPoints:
                    if left.totalPoints == right.totalPoints {
                        return left.price > right.price
                    }
                    return left.totalPoints > right.totalPoints
                case .price:
                    if left.price == right.price {
                        return left.totalPoints > right.totalPoints
                    }
                    return left.price > right.price
                }
            })
        }
    }

}

private extension SquadPlayer.Position {
    var title: String {
        switch self {
        case .goalkeeper:
            return "Goalkeepers"
        case .defender:
            return "Defenders"
        case .midfielder:
            return "Midfielders"
        case .forward:
            return "Forwards"
        }
    }
}

// View Model for the row item
struct PlayerCellViewModel: Hashable {
    let name: String
    let details: String
    let totalPoints: Int
    let price: Int
    
    init(from domainModel: SquadPlayer) {
        self.name = "\(domainModel.firstName) \(domainModel.lastName)"
        self.details = "£\(domainModel.price)m  •  \(domainModel.totalPoints) pts"
        self.totalPoints = domainModel.totalPoints
        self.price = domainModel.price
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
    let title: String
}
