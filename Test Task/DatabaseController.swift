//
//  DatabaseController.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 25/03/24.
//

import Foundation
import CoreData

class DatabaseController {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Test_Task")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
