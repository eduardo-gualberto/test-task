//
//  ViewController.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import UIKit

class MasterViewController: UIViewController {
    let viewModel = MasterViewModel()
    var persons: [PersonModel] = []
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        toggleLoadingView(.on)
        viewModel.fetchPersonsList{
            persons in
            self.persons = persons
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.toggleLoadingView(.off)
            }
        }
    }
}


//MARK: UITableViewDataSource
extension MasterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "masterCell", for: indexPath) as! MasterTableCell
        
        let person = persons[indexPath.row]
        cell.setPersonName(person.name)
        cell.setWonDeals(person.wonDealsCount)
        cell.setLostDeals(person.lostDealsCount)
        cell.setDimmed(person.orgName ?? person.primaryEmail)
        
        return cell
    }
}

//MARK: Utilities
extension MasterViewController {
    enum LoadingViewState {
        case on, off
    }
    
    private func toggleLoadingView(_ option: LoadingViewState) {
        switch option {
        case .on:
            loadingView.isHidden = false
            loadingView.startAnimating()
        case .off:
            loadingView.isHidden = true
            loadingView.stopAnimating()
        }
    }
}
