//
//  TeamsListViewController.swift
//  TeamsList
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

import UIKit

class TeamsListViewController: UIViewController {
    var viewModel: TeamsViewModelRepresentable?
    
    // MARK: - UI Elements
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: - Diffable Data Source
    private enum Section { case main }
    private var dataSource: UITableViewDiffableDataSource<Section, TeamViewModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTableView()
        configureDataSource()
        fetchTeams()
    }
    
    private func fetchTeams() {
        guard let viewModel else {
            return
        }
        
        Task {
            let viewModels = try await viewModel.fetchTeams()
            updateUI(with: viewModels)
        }
    }
    
    // MARK: - Setup
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TeamCell")
        
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, TeamViewModel>(tableView: tableView) { tableView, indexPath, viewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            
            // Use modern content configurations for rendering text
            var content = cell.defaultContentConfiguration()
            content.text = viewModel.title
            content.secondaryText = viewModel.subtitle
            content.secondaryTextProperties.color = .secondaryLabel
            
            cell.contentConfiguration = content
            return cell
        }
    }
    
    // MARK: - Data Management
    private func updateUI(with viewModels: [TeamViewModel]) {
        // Apply snapshot to update the table view
        var snapshot = NSDiffableDataSourceSnapshot<Section, TeamViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModels)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension TeamsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. Deselect the row immediately with a smooth fade-out animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 2. Safely retrieve the view model associated with the tapped row
        guard let selectedTeam = dataSource.itemIdentifier(for: indexPath) else { return }
        
        // 3. Perform your action (e.g., Navigate to a detail view controller)
        print("Tapped on team: \(selectedTeam.title)")
        viewModel?.teamCellTapped()
        
        // Example Navigation:
        // let detailVC = TeamDetailViewController(team: selectedTeam)
        // navigationController?.pushViewController(detailVC, animated: true)
    }
}
