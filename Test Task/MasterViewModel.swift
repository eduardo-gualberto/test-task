//
//  ViewModel.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import Foundation

class MasterViewModel {
    let listAllPersonsUseCase = ListAllPersonsUseCase()
    
    func fetchPersonsList(completion: @escaping ([PersonModel]) -> Void) {
        listAllPersonsUseCase.use { result in
            switch result {
            case .success(let persons):
                completion(persons)
            case .failure(let error):
                debugPrint(error)
                completion([])
            }
        }
    }
}
