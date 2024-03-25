//
//  ViewModel.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import UIKit
import SkeletonView

protocol MasterViewModelProtocol {
    func fetchPersonsList() async -> Void
    func openDetail(for person: PersonModel)
}

class MasterViewModel: MasterViewModelProtocol {
    var coordinator: AppCoordinatorProtocol!
    weak var vc: MasterViewControllerProtocol?
    
    let listAllPersonsUseCase = ListAllPersonsUseCase()
    
    @MainActor
    func fetchPersonsList() async {
        let result = await listAllPersonsUseCase.use()
        
        switch result {
        case .success(let persons):
            vc?.updatePersonsData(with: persons)
        case .failure(let error):
            vc?.presentError(error: error)
        }
    }
    
    func openDetail(for person: PersonModel){
        guard let vc = self.vc else { return }
        coordinator.goToDetail(person: person, from: vc)
    }
}
