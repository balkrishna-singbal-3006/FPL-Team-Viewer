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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTableView()
        configureDataSource()
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
        var snapshot = NSDiffableDataSourceSnapshot<PositionSection, PlayerCellViewModel>()
        guard let viewModel else {
            return
        }
        
        // Drive layout completely off of ViewModel state outputs
        let sections = viewModel.sections
        snapshot.appendSections(sections)
        
        for section in sections {
            if let items = viewModel.itemsPerSection[section] {
                snapshot.appendItems(items, toSection: section)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UITableViewDelegate
extension TeamSquadViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        print("Inside titleForHeaderInSection...")
//        return viewModel?.sections[section].title
//    }
    
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
