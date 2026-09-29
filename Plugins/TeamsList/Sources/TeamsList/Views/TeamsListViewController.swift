//
//  TeamsListViewController.swift
//  TeamsList
//
//  Created by Balkrishna Nitin Singbal on 9/29/26.
//

import UIKit

class TeamsListViewController: UIViewController {
    var viewModel: TeamsViewModelRepresentable?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .brown
        viewModel?.fetchTeams()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
