//
//  ViewModel.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import UIKit
import SkeletonView

protocol MasterViewModelProtocol {
    func fetchPersonsList(completion: @escaping ([PersonModel]) -> Void)
    func openDetail(for person: PersonModel)
}

class MasterViewModel: MasterViewModelProtocol {
    var coordinator: AppCoordinatorProtocol!
    weak var vc: MasterViewControllerProtocol?
    
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
        guard let vc = self.vc else { return }
        coordinator.goToDetail(person: person, from: vc)
    }
}
