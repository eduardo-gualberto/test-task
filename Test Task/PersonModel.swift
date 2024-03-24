//
//  PersonModel.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import Foundation

struct PersonPhone: Codable {
    let label: String?
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
    let orgName: String?
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
}

