//
//  ViewController.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import UIKit
import SkeletonView

class MasterViewController: UIViewController {
    var persons: [PersonModel] = []
    let viewModel = MasterViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
                
        viewModel.fetchPersonsList {
            persons in
            self.persons = persons
            
            DispatchQueue.main.async {
                self.tableView.stopSkeletonAnimation()
                self.tableView.hideSkeleton()
                
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton()
    }
}

//MARK: Navigation
extension MasterViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? DetailViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        detailsVC.person = persons[indexPath.row]
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: UITableViewDataSource
extension MasterViewController: SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MasterTableCell.identifier, for: indexPath) as! MasterTableCell

        let person = persons[indexPath.row]
        
        cell.setPersonName(person.name)
        cell.setDimmed(person.orgName ?? person.ownerName)

        return cell
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return MasterTableCell.identifier
    }
}
