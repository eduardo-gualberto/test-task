//
//  PersonModel.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import Foundation

struct PersonPhone: Codable {
    let label: String
    let value: String
    let primary: Bool
}

struct PersonOrg : Codable {
    let name: String
    let ccEmail: String
    let ownerName: String
    let peopleCount: Int
}

struct PersonOwner : Codable {
    let name: String
    let email: String
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
}
