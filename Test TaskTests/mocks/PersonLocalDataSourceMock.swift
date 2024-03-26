//
//  PersonLocalDataSource.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 25/03/24.
//

import Foundation
@testable import Test_Task
import CoreData


struct PersonLocalDataSourceMock {
    func fetchAll() -> Result<[PersonModel], PersonError> {
        print("fetching")
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
    
    func dropDatabase() {
        let results = try! DatabaseController.persistentContainer.viewContext.fetch(PersonEntity.fetchRequest()) as! [NSManagedObject]
        
        let context = DatabaseController.persistentContainer.viewContext
        
        for object in results {
            context.delete(object)
        }
        
        DatabaseController.saveContext()
    }
    
    func insertObject(person: PersonModel) {
        DatabaseController.persistentContainer.viewContext.performAndWait {
            let _ = person.toEntity()
            
            DatabaseController.saveContext()
            print("saved")
        }
    }
}

