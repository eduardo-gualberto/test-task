//
//  PersonModel.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import Foundation

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
    let activeFlag: Bool
}

