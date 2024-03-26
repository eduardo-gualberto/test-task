//
//  PersonLocalDataSource.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 25/03/24.
//

import Foundation

struct PersonLocalDataSource {
    func fetchAll() -> Result<[PersonModel], PersonError> {
        do {
            let results = try DatabaseController.persistentContainer.viewContext.fetch(PersonEntity.fetchRequest()) as! [PersonEntity]
            
            let personModels = results.map { entity in
                return PersonModel.fromEntity(entity)!
            }
            return .success(personModels)
        } catch(_) {
            return .failure(.localDBFail)
        }
    }
}
