//
//  ListAllPersonsUseCase.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import Foundation

struct ListAllPersonsUseCase {
    let personRepository = PersonRepository()
    
    func use(completion: @escaping (Result<[PersonModel], PersonError>) -> Void) {
        return personRepository.fetchAll(completion: completion)
    }
}
