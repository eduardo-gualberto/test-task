//
//  PersonModel.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import Foundation
import CoreData

struct PersonPhone: Codable {
    let label: String
    let value: String
    let primary: Bool
    
    static func fromEntity(_ entity: PersonPhoneEntity) -> PersonPhone? {
        guard let label = entity.label, let value = entity.value else { return nil }
        return PersonPhone(label: label, value: value, primary: entity.primary)
    }
    
    func toEntity() -> PersonPhoneEntity {
        let entity = NSEntityDescription.entity(forEntityName: "PersonPhoneEntity", in: DatabaseController.persistentContainer.viewContext)!
        let personObj = NSManagedObject(entity: entity, insertInto: DatabaseController.persistentContainer.viewContext) as! PersonPhoneEntity
        
        personObj.label = label
        personObj.primary = primary
        personObj.value = value
        
        return personObj
    }
}

struct PersonOrg : Codable {
    let name: String
    let ccEmail: String
    let ownerName: String
    let peopleCount: Int
    
    func toEntity() -> PersonOrgEntity {
        let entity = NSEntityDescription.entity(forEntityName: "PersonOrgEntity", in: DatabaseController.persistentContainer.viewContext)!
        let personObj = NSManagedObject(entity: entity, insertInto: DatabaseController.persistentContainer.viewContext) as! PersonOrgEntity
        
        personObj.name = name
        personObj.ccEmail = ccEmail
        personObj.ownerName = ownerName
        personObj.peopleCount = Int32(peopleCount)
        
        return personObj
    }
    
    static func fromEntity(_ entity: PersonOrgEntity?) -> PersonOrg? {
        guard let entity = entity, let name = entity.name, let ccEmail = entity.ccEmail, let ownerName = entity.ownerName else { return nil }
        
        return PersonOrg(name: name, ccEmail: ccEmail, ownerName: ownerName, peopleCount: Int(entity.peopleCount))
    }
}

struct PersonOwner : Codable {
    let name: String
    let email: String
    
    func toEntity() -> PersonOwnerEntity {
        let entity = NSEntityDescription.entity(forEntityName: "PersonOwnerEntity", in: DatabaseController.persistentContainer.viewContext)!
        let personObj = NSManagedObject(entity: entity, insertInto: DatabaseController.persistentContainer.viewContext) as! PersonOwnerEntity
        
        personObj.name = name
        personObj.email = email
        
        return personObj
    }
    
    static func fromEntity(_ entity: PersonOwnerEntity) -> PersonOwner? {
        guard let name = entity.name, let email = entity.email else { return nil }
        return PersonOwner(name: name, email: email)
    }
}

struct PersonModel: Codable {
    let id: Int
    let name: String
    let primaryEmail: String
    let ownerName: String
    let orgName: String
    let openDealsCount: Int
    let closedDealsCount: Int
    let wonDealsCount: Int
    let lostDealsCount: Int
    let activitiesCount: Int
    let doneActivitiesCount: Int
    let undoneActivitiesCount: Int
    let lastActivityDate: Date?
    let activeFlag: Bool
    let phone: [PersonPhone]
    let orgId: PersonOrg?
    let ownerId: PersonOwner
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unknown"
        self.primaryEmail = try container.decodeIfPresent(String.self, forKey: .primaryEmail) ?? "Unknown"
        self.ownerName = try container.decodeIfPresent(String.self, forKey: .ownerName) ?? "Unknown"
        self.orgName = try container.decodeIfPresent(String.self, forKey: .orgName) ?? "Unknown"
        self.openDealsCount = try container.decodeIfPresent(Int.self, forKey: .openDealsCount) ?? 0
        self.closedDealsCount = try container.decodeIfPresent(Int.self, forKey: .closedDealsCount) ?? 0
        self.wonDealsCount = try container.decodeIfPresent(Int.self, forKey: .wonDealsCount) ?? 0
        self.lostDealsCount = try container.decodeIfPresent(Int.self, forKey: .lostDealsCount) ?? 0
        self.activitiesCount = try container.decodeIfPresent(Int.self, forKey: .activitiesCount) ?? 0
        self.doneActivitiesCount = try container.decodeIfPresent(Int.self, forKey: .doneActivitiesCount) ?? 0
        self.undoneActivitiesCount = try container.decodeIfPresent(Int.self, forKey: .undoneActivitiesCount) ?? 0
        self.lastActivityDate = try container.decodeIfPresent(Date.self, forKey: .lastActivityDate)
        self.activeFlag = try container.decodeIfPresent(Bool.self, forKey: .activeFlag) ?? false
        self.phone = (try? container.decodeIfPresent([PersonPhone].self, forKey: .phone)) ?? [PersonPhone(label: "Unknown", value: "Unknown", primary: false)]
        self.orgId = try container.decodeIfPresent(PersonOrg.self, forKey: .orgId)
        self.ownerId = try container.decodeIfPresent(PersonOwner.self, forKey: .ownerId) ?? PersonOwner(name: "Unknown", email: "Unknown")
    }
    
    init?(id: Int,
          name: String,
          primaryEmail: String,
          ownerName: String,
          orgName: String,
          openDealsCount: Int,
          closedDealsCount: Int,
          wonDealsCount: Int,
          lostDealsCount: Int,
          activitiesCount: Int,
          doneActivitiesCount: Int,
          undoneActivitiesCount: Int,
          lastActivityDate: Date?,
          activeFlag: Bool,
          phone: [PersonPhone],
          orgId: PersonOrg?,
          ownerId: PersonOwner) {
        self.id = id
        self.name = name
        self.primaryEmail = primaryEmail
        self.ownerName = ownerName
        self.orgName = orgName
        self.openDealsCount = openDealsCount
        self.closedDealsCount = closedDealsCount
        self.wonDealsCount = wonDealsCount
        self.lostDealsCount = lostDealsCount
        self.activitiesCount = activitiesCount
        self.doneActivitiesCount = doneActivitiesCount
        self.undoneActivitiesCount = undoneActivitiesCount
        self.lastActivityDate = lastActivityDate
        self.activeFlag = activeFlag
        self.phone = phone
        self.orgId = orgId
        self.ownerId = ownerId
    }
    
    static func fromEntity(_ entity: PersonEntity) -> PersonModel? {
        guard let phone = entity.phone, let owner = entity.ownerId else { return nil }
        let phoneModel = PersonPhone.fromEntity(phone.allObjects.first as! PersonPhoneEntity)!
        let ownerModel = PersonOwner.fromEntity(owner)!
        let orgModel = PersonOrg.fromEntity(entity.orgId)

        return PersonModel(id: Int(entity.id), name: entity.name!, primaryEmail: entity.primaryEmail!, ownerName: entity.ownerName!, orgName: entity.orgName!, openDealsCount: Int(entity.openDealsCount), closedDealsCount: Int(entity.closedDealsCount), wonDealsCount: Int(entity.wonDealsCount), lostDealsCount: Int(entity.lostDealsCount), activitiesCount: Int(entity.activitiesCount), doneActivitiesCount: Int(entity.doneActivitiesCount), undoneActivitiesCount: Int(entity.undoneActivitiesCount), lastActivityDate: entity.lastActivityDate, activeFlag: entity.activeFlag, phone: [phoneModel], orgId: orgModel, ownerId: ownerModel)
    }
    
    func toEntity() -> PersonEntity {
        let entity = NSEntityDescription.entity(forEntityName: "PersonEntity", in: DatabaseController.persistentContainer.viewContext)!
        let personObj = NSManagedObject(entity: entity, insertInto: DatabaseController.persistentContainer.viewContext) as! PersonEntity

        personObj.id = Int32(id)
        personObj.activeFlag = activeFlag
        personObj.activitiesCount = Int32(activitiesCount)
        personObj.closedDealsCount = Int32(closedDealsCount)
        personObj.doneActivitiesCount = Int32(doneActivitiesCount)
        personObj.lastActivityDate = lastActivityDate
        personObj.lostDealsCount = Int32(lostDealsCount)
        personObj.name = name
        personObj.openDealsCount = Int32(openDealsCount)
        personObj.orgName = orgName
        personObj.ownerName = ownerName
        personObj.primaryEmail = primaryEmail
        personObj.undoneActivitiesCount = Int32(undoneActivitiesCount)
        personObj.wonDealsCount = Int32(wonDealsCount)
        
        personObj.phone = NSSet(array: self.phone.map({ phone in
            return phone.toEntity()
        }))
        
        if let orgId = orgId {
            personObj.orgId = orgId.toEntity()
        }
        
        personObj.ownerId = ownerId.toEntity()
        
        return personObj
    }
}
