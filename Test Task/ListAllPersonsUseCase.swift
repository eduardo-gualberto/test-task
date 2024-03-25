//
//  ListAllPersonsUseCase.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import Foundation

struct ListAllPersonsUseCase {
    let personRepository = PersonRepository()
    
    func use() async -> PersonsResult {
        return await personRepository.fetchAll()
    }
}
