//
//  ViewController.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import UIKit
import SkeletonView
import CoreData

protocol MasterViewControllerProtocol where Self: UIViewController {
    func presentError(error: PersonError)
    func updatePersonsData(with data: [PersonModel])
}

class MasterViewController: UIViewController, MasterViewControllerProtocol, Storyboarded {
    
    static let identifier = "masterViewController"
    var viewModel: MasterViewModelProtocol!
    
    var persons: [PersonModel] = []
    var allowEmptyView = false
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAlly()
        
        tableView.dataSource = self
        tableView.delegate = self
                
        Task { 
            await viewModel.fetchPersonsList()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton()
    }

    func presentError(error: PersonError) {
        print(error)
    }
    
    func updatePersonsData(with data: [PersonModel]) {
        self.allowEmptyView = true
        self.persons = data
        self.tableView.stopSkeletonAnimation()
        self.tableView.hideSkeleton()
        
        self.tableView.reloadData()
    }
}

//MARK: UITableViewDelegate
extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.openDetail(for: persons[indexPath.row])
    }
    
}

//MARK: UITableViewDataSource
extension MasterViewController: SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if persons.count == 0 && allowEmptyView {
            tableView.setEmptyView(title: "No one to show.", message: "Your contacts will be in here")
        } else {
            tableView.restore()
        }
        
        return persons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MasterTableCell.identifier, for: indexPath) as! MasterTableCell

        let person = persons[indexPath.row]
        
        cell.setPersonName(person.name)
        let dimmedField = person.orgName == "Unknown" ? person.ownerName : person.orgName
        cell.setDimmed(dimmedField)
        cell.setupAlly()

        return cell
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return MasterTableCell.identifier
    }
}
