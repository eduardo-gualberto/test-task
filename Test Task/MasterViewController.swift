//
//  ViewController.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import UIKit

class MasterViewController: UIViewController {
    let viewModel = MasterViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.vc = self
        tableView.dataSource = viewModel
        
        viewModel.fetchPersonsList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton()
    }
}
