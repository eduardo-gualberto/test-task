//
//  DetailViewModel.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 23/03/24.
//

import Foundation

protocol DetailViewModelProtocol {
    var person: PersonModel! { get }
    func getTableViewSections() -> [DetailTableViewSection]
    func getTableViewSectionsCount() -> Int
    func getTableViewSection(for index: Int) -> DetailTableViewSection
}

struct DetailTableViewSection {
    let name: String
    let items: [[String:String]]
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
        let contactItems = [["phone": person.phone[0].value], ["email": person.primaryEmail]]
        let contactSection = DetailTableViewSection(name: "Contact", items: contactItems, empty: false)
        
        return contactSection
    }
    
    private func createDealsSection() -> DetailTableViewSection {
        let dealsItems = [["won": "\(person.wonDealsCount)"], ["lost": "\(person.lostDealsCount)"]]
        let dealsSection = DetailTableViewSection(name: "Deals", items: dealsItems, empty: false)
        
        return dealsSection
    }
    
    private func createActivitiesSection() -> DetailTableViewSection {
        var activitiesItems = [["done": "\(person.doneActivitiesCount)"], ["undone": "\(person.undoneActivitiesCount)"], ["total": "\(person.activitiesCount)"]]
        if let lastActivityDate = person.lastActivityDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            let lastActivityDateFormatted = dateFormatter.string(from: lastActivityDate)
            
            activitiesItems.append(["last": lastActivityDateFormatted])
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
        
        let items = [["name": org.name.deletingPrefix("[Sample] ")], ["email": org.ccEmail], ["people": "\(org.peopleCount)"], ["owner": org.ownerName]]
        
        let orgSection = DetailTableViewSection(name: "Organisation", items: items, empty: false)
        
        return orgSection
    }
    
    private func createOwnerSection() -> DetailTableViewSection {
        let owner = person.ownerId
        
        let items = [["name": owner.name], ["email": owner.email]]
        
        let ownerSection = DetailTableViewSection(name: "Owner", items: items, empty: false)
        
        return ownerSection
    }
}
