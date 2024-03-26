//
//  DetailViewModel.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 23/03/24.
//

import Foundation

enum DetailTableKeys : String {
    case phone, contactEmail
    
    case won, lost
    
    case done, undone, total, last
    
    case orgName, orgEmail, people, owner
    
    case ownerName, ownerEmail
}

protocol DetailViewModelProtocol {
    var person: PersonModel! { get }
    func getTableViewSections() -> [DetailTableViewSection]
    func getTableViewSectionsCount() -> Int
    func getTableViewSection(for index: Int) -> DetailTableViewSection
}

struct DetailTableViewSection {
    let name: String
    let items: [[DetailTableKeys: String]]
    let empty: Bool
}

final class DetailViewModel: DetailViewModelProtocol {
    var person: PersonModel!
    var coordinator: AppCoordinatorProtocol!

    lazy private var sections: [DetailTableViewSection] = {
        let contactSection = createContactSection()
        let dealsSection = createDealsSection()
        let activitiesSection = createActivitiesSection()
        let orgOrOwnerSection = createOrgOrOwnerSection()
        
        return [contactSection, dealsSection, activitiesSection, orgOrOwnerSection]
    }()
    
    func getTableViewSections() -> [DetailTableViewSection] {
        return self.sections
    }
    
    func getTableViewSectionsCount() -> Int {
        return self.sections.count
    }
    
    func getTableViewSection(for index: Int) -> DetailTableViewSection {
        return self.sections[index]
    }
}

//MARK: Utilities
extension DetailViewModel {
    private func createContactSection() -> DetailTableViewSection {
        let contactItems: [[DetailTableKeys: String]] = [[.phone: person.phone[0].value], [.contactEmail: person.primaryEmail]]
        let contactSection = DetailTableViewSection(name: "Contact", items: contactItems, empty: false)
        
        return contactSection
    }
    
    private func createDealsSection() -> DetailTableViewSection {
        let dealsItems: [[DetailTableKeys: String]] = [[.won: "\(person.wonDealsCount)"], [.lost: "\(person.lostDealsCount)"]]
        let dealsSection = DetailTableViewSection(name: "Deals", items: dealsItems, empty: false)
        
        return dealsSection
    }
    
    private func createActivitiesSection() -> DetailTableViewSection {
        var activitiesItems: [[DetailTableKeys: String]] = [[.done: "\(person.doneActivitiesCount)"], [.undone: "\(person.undoneActivitiesCount)"], [.total: "\(person.activitiesCount)"]]
        if let lastActivityDate = person.lastActivityDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            let lastActivityDateFormatted = dateFormatter.string(from: lastActivityDate)
            
            activitiesItems.append([.last: lastActivityDateFormatted])
        }
        let activitiesSection = DetailTableViewSection(name: "Activities", items: activitiesItems, empty: false)
        
        return activitiesSection
    }
    
    private func createOrgOrOwnerSection() -> DetailTableViewSection {
        let orgSection = createOrgSection()
        if orgSection.empty {
            return createOwnerSection()
        }
        return orgSection
    }
    
    private func createOrgSection() -> DetailTableViewSection {
        guard let org = person.orgId else { return DetailTableViewSection(name: "", items: [], empty: true) }
        
        let items: [[DetailTableKeys: String]] = [[.orgName: org.name.deletingPrefix("[Sample] ")], [.orgEmail: org.ccEmail], [.people: "\(org.peopleCount)"], [.owner: org.ownerName]]
        
        let orgSection = DetailTableViewSection(name: "Organisation", items: items, empty: false)
        
        return orgSection
    }
    
    private func createOwnerSection() -> DetailTableViewSection {
        let owner = person.ownerId
        
        let items: [[DetailTableKeys: String]] = [[.ownerName: owner.name], [.ownerEmail: owner.email]]
        
        let ownerSection = DetailTableViewSection(name: "Owner", items: items, empty: false)
        
        return ownerSection
    }
}
