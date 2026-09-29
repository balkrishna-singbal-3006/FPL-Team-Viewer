//
//  ViewController.swift
//  FPL Team Viewer
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

import UIKit
import PluginAPIs
import TeamsList
import TeamSquad

class ViewController: UIViewController {
    private var teamsListAPI: TeamsListAPI?
    private var teamsSquadAPI: TeamSquadAPI?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func startTeamViewer(_ sender: Any) {
        // TODO: Implement container for storing the APIs.
        teamsSquadAPI = TeamSquadPluginAPI()
        teamsListAPI = TeamsListPluginAPI(teamSquadAPI: teamsSquadAPI!)
        guard let navigationController else {
            return
        }
        teamsListAPI?.showTeamsListScreen(navigationController: navigationController)
    }
}

