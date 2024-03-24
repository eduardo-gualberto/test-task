//
//  ViewModel.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import UIKit
import SkeletonView

class MasterViewModel {
    var coordinator: AppCoordinator!
    weak var vc: MasterViewController!
    
    let listAllPersonsUseCase = ListAllPersonsUseCase()
    
    func fetchPersonsList(completion: @escaping ([PersonModel]) -> Void) {
        listAllPersonsUseCase.use { result in
            switch result {
            case .success(let persons):
                completion(persons)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func openDetail(for person: PersonModel){
        coordinator.goToDetail(person: person, from: vc)
    }
}
