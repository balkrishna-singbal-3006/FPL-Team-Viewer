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
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    // 1. Add the container view and subviews for the error state screen
    private let errorContainerView = UIView()
    private let errorLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    
    // MARK: - Diffable Data Source
    private enum Section { case main }
    private var dataSource: UITableViewDiffableDataSource<Section, TeamViewModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        setupTableView()
        setupLoadingIndicator()
        setupErrorView() // 2. Set up constraints for the error card layout
        configureDataSource()
        fetchTeams(isRefreshing: false)
    }
    
    private func fetchTeams(isRefreshing: Bool) {
        guard let viewModel else {
            return
        }
        
        if !isRefreshing {
            loadingIndicator.startAnimating()
        }
        
        Task {
            do {
                let viewModels = try await viewModel.fetchTeams()
                await MainActor.run {
                    self.stopAllLoadingIndicators()
                    self.tableView.isHidden = false
                    self.updateUI(with: viewModels)
                }
            } catch {
                await MainActor.run {
                    self.stopAllLoadingIndicators()
                    // 4. Show the error layout if there is no pre-existing row data in the table view
                    let currentlyHasData = self.dataSource.snapshot().numberOfItems > 0
                    if !currentlyHasData {
                        self.tableView.isHidden = true
                        self.errorContainerView.isHidden = false
                        self.errorLabel.text = "Failed to load teams.\nPlease check your connection."
                    } else {
                        // If we already have cached row items via pull-to-refresh, just print or show a brief toast
                        print("Background refresh error: \(error)")
                    }
                }
            }
        }
    }
    
    private func stopAllLoadingIndicators() {
        loadingIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TeamCell")
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // 5. Construct the full-screen error view constraints & components
    private func setupErrorView() {
        view.addSubview(errorContainerView)
        errorContainerView.translatesAutoresizingMaskIntoConstraints = false
        errorContainerView.isHidden = true // Default hidden state
        
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.textColor = .secondaryLabel
        errorLabel.font = .systemFont(ofSize: 16, weight: .regular)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        retryButton.setTitle("Try Again", for: .normal)
        retryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        retryButton.addTarget(self, action: #selector(handleRetry), for: .touchUpInside)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        
        errorContainerView.addSubview(errorLabel)
        errorContainerView.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            // Center container view in parent controller bounds
            errorContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            errorContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Stack elements vertically inside container layout bounds
            errorLabel.topAnchor.constraint(equalTo: errorContainerView.topAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: errorContainerView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: errorContainerView.trailingAnchor),
            
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: errorContainerView.centerXAnchor),
            retryButton.bottomAnchor.constraint(equalTo: errorContainerView.bottomAnchor)
        ])
    }
    
    @objc private func handleRefresh() {
        fetchTeams(isRefreshing: true)
    }
    
    // 6. Objective-C execution target connected to button tap sequence
    @objc private func handleRetry() {
        fetchTeams(isRefreshing: false)
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true // Automatically hides when stopped
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
        viewModel?.teamCellTapped(for: selectedTeam)
    }
}
