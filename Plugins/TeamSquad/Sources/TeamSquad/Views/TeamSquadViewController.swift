//
//  TeamSquadViewController.swift
//  TeamSquad
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

import UIKit

class TeamSquadViewController: UIViewController {
    var viewModel: TeamSquadViewModelRepresentable?
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource: TeamSquadDataSource!
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search by name"
        sc.searchBar.autocapitalizationType = .none
        sc.searchBar.autocorrectionType = .no
        sc.searchResultsUpdater = self
        return sc
    }()

    private var currentSearchText: String = ""

    private var isFiltering: Bool {
        let text = currentSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return navigationItem.searchController?.isActive == true && !text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTableView()
        configureDataSource()
        // Attach the search bar to the navigation bar
        navigationItem.searchController = searchController
        definesPresentationContext = true

        // Optional: nicer UX when scrolling the table
        tableView.keyboardDismissMode = .onDrag
        
        applySnapshot()
    }
    
    // MARK: - Setup & Bindings
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlayerCell")
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureDataSource() {
        // 2. Instantiate using your custom PlayerListDataSource subclass
        dataSource = TeamSquadDataSource(tableView: tableView) { tableView, indexPath, cellViewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
            cell.accessoryType = .none
            
            var content = cell.defaultContentConfiguration()
            content.text = cellViewModel.name
            content.secondaryText = cellViewModel.details
            content.secondaryTextProperties.color = .secondaryLabel
            
            cell.contentConfiguration = content
            return cell
        }
    }
    
    private func applySnapshot() {
        guard let viewModel else { return }

        // Example shape—replace with your actual accessors/types
        // let allSections: [TeamSquadSectionViewModel] = viewModel.sections
        // where TeamSquadSectionViewModel has: `sectionID` and `items: [PlayerItem]`

        let allSections = viewModel.sections // Replace with your actual sections

        let visibleSections = allSections.compactMap { section -> (sectionID: PositionSection, items: [PlayerCellViewModel])? in
            guard let itemsPerSection = viewModel.itemsPerSection[section] else {
                return nil
            }
            let filteredItems = itemsPerSection.filter(matches(_:))
            if isFiltering {
                // Hide sections with no matches
                return filteredItems.isEmpty ? nil : (section, filteredItems)
            } else {
                return (section, itemsPerSection)
            }
        }

        var snapshot = NSDiffableDataSourceSnapshot<PositionSection, PlayerCellViewModel>()
        visibleSections.forEach { pair in
            snapshot.appendSections([pair.sectionID])
            snapshot.appendItems(pair.items, toSection: pair.sectionID)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func matches(_ item: PlayerCellViewModel) -> Bool {
        let query = currentSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }

        let lhs = item.name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
        let rhs = query.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
        return lhs.contains(rhs)
    }
}

// MARK: - UITableViewDelegate
extension TeamSquadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cellViewModel = dataSource.itemIdentifier(for: indexPath) else { return }
        
        // Pass the player payload over to your flow coordinator or details layer
        print("MVVM Routing for: \(cellViewModel.name)")
    }
}

class TeamSquadDataSource: UITableViewDiffableDataSource<PositionSection, PlayerCellViewModel> {
    
    // This is the internal method UIKit calls to determine section header text
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currentSnapshot = snapshot()
        guard section < currentSnapshot.sectionIdentifiers.count else { return nil }
        return currentSnapshot.sectionIdentifiers[section].title
    }
}

extension TeamSquadViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        currentSearchText = searchController.searchBar.text ?? ""
        applySnapshot()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentSearchText = ""
        applySnapshot()
    }
}
