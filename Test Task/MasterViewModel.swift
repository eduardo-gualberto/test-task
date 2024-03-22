//
//  ViewModel.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import UIKit
import SkeletonView

class MasterViewModel: NSObject {
    weak var vc: MasterViewController?
    var persons: [PersonModel] = []
    let listAllPersonsUseCase = ListAllPersonsUseCase()
    
    func fetchPersonsList() {
        listAllPersonsUseCase.use { result in
            switch result {
            case .success(let persons):
                self.handlePersonsSuccess(persons)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

//MARK: UITableViewDataSource
extension MasterViewModel: SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MasterTableCell.identifier, for: indexPath) as! MasterTableCell

        let person = persons[indexPath.row]
        cell.setPersonName(person.name)
        cell.setWonDeals(person.wonDealsCount)
        cell.setLostDeals(person.lostDealsCount)
        cell.setDimmed(person.orgName ?? person.primaryEmail)

        return cell
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return MasterTableCell.identifier
    }
}

//MARK: Utilities
extension MasterViewModel {
    private func handlePersonsSuccess(_ persons: [PersonModel]) {
        self.persons = persons
        guard let vc = self.vc else { return }
        
        //TODO: GCD -> async/await
        DispatchQueue.main.async {
            vc.tableView.stopSkeletonAnimation()
            vc.view.hideSkeleton()
            
            vc.tableView.reloadData()
        }
    }
}
