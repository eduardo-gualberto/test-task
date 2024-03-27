//
//  Master.swift
//  Test TaskTests
//
//  Created by Eduardo Gualberto on 26/03/24.
//

import XCTest
@testable import Test_Task

final class Test_TaskTests: XCTestCase {

    let remoteMock = PersonRemoteDataSourceMock()
    let localMock = PersonLocalDataSourceMock()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        localMock.dropDatabase()
    }
    
    //MARK: RemoteDataSource
    func testRemoteSuccessOrFetchingErrorWithoutPurpose() async throws {
        let result = await remoteMock.fetchAll()
        switch result {
        //if it fails its because of connection issues
        case .failure(let error):
            XCTAssertEqual(error, .dataFetchingError)
        case .success(let persons):
            XCTAssertFalse(persons.isEmpty)
        }
    }
    
    //MARK: LocalDataSource
    func testLocalReturnEmptyOnFirstBoot() throws {
        let result = localMock.fetchAll()
        
        switch result {
        case .success(let persons):
            XCTAssertEqual(persons.count, 0)
        case .failure(_):
            XCTAssertTrue(false)
        }
    }
    
    func testLocalReturnAfterRemoteCall() async throws {
        let remoteResults = try (await remoteMock.fetchAll(save: true)).get()
        
        //execute after 2 seconds to avoid race conditions
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let localResults = try? self.localMock.fetchAll().get() {
                XCTAssertEqual(remoteResults.count, localResults.count)
            }
        }
    }
    
    func testLocalDataOverwrite() async throws {
        let remoteResults = try (await remoteMock.fetchAll(save: true)).get()

        // "o" is already present in the local db, as remote data source saves it to the device
        let o = remoteResults.first!
        
        // creates an object with o's id and updates closedDealsCount field
        let updatedObject = PersonModel(id: o.id, name: o.name, primaryEmail: o.primaryEmail, ownerName: o.ownerName, orgName: o.orgName, openDealsCount: o.openDealsCount, closedDealsCount: o.closedDealsCount + 1, wonDealsCount: o.wonDealsCount, lostDealsCount: o.lostDealsCount, activitiesCount: o.activitiesCount, doneActivitiesCount: o.doneActivitiesCount, undoneActivitiesCount: o.undoneActivitiesCount, lastActivityDate: o.lastActivityDate, activeFlag: o.activeFlag, phone: o.phone, orgId: o.orgId, ownerId: o.ownerId)!
        
        // save o's update to the local db with overwrite policy set
        localMock.insertObject(person: updatedObject)
        
        // avoid race conditions
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let dbObject = try? self.localMock.fetchAll().get().first(where: { pm in
                pm.id == updatedObject.id
            })! {
                // the database closedDealsCount version should be 1 unit greater then o's
                XCTAssertGreaterThan(dbObject.closedDealsCount, o.closedDealsCount)
            }
        }
    }
    
    //MARK: PersonModel
    func testPersonModelFromEntity() throws {
        let entity = createPersonEntity()
        let model = PersonModel.fromEntity(entity)
        
        XCTAssertEqual(entity.name, model?.name)
        XCTAssertEqual(entity.orgName, model?.orgName)
        XCTAssertEqual((entity.phone?.allObjects.first as? PersonPhoneEntity)?.value, model?.phone.first?.value)
        XCTAssertEqual(entity.orgId?.name, model?.orgId?.name)
        XCTAssertEqual(entity.ownerId?.name, model?.ownerId.name)
    }
    
    func testPersonModelToEntityAgainstFromEntity() {
        let originalEntity = createPersonEntity()
        let model = PersonModel.fromEntity(originalEntity)!
        let generatedEntity = model.toEntity()
        
        XCTAssertEqual(originalEntity.id, generatedEntity.id)
        XCTAssertEqual(originalEntity.name, generatedEntity.name)
        XCTAssertEqual((originalEntity.phone?.allObjects.first as? PersonPhoneEntity)?.value, (generatedEntity.phone?.allObjects.first as? PersonPhoneEntity)?.value)
        XCTAssertEqual(originalEntity.orgId?.name, generatedEntity.orgId?.name)
        XCTAssertEqual(originalEntity.ownerId?.email, generatedEntity.ownerId?.email)

    }
}


//MARK: Utilities
extension Test_TaskTests {
    private func createPersonEntity() -> PersonEntity {
        let entity = PersonEntity(context: DatabaseController.persistentContainer.viewContext)
        
        let phoneEntity = PersonPhoneEntity(context: DatabaseController.persistentContainer.viewContext)
        phoneEntity.label = "testing label"
        phoneEntity.primary = true
        phoneEntity.value = "testing value"
        
        let orgEntity = PersonOrgEntity(context: DatabaseController.persistentContainer.viewContext)
        orgEntity.ccEmail = "testing email"
        orgEntity.name = "testing name"
        orgEntity.ownerName = "testing ownername"
        orgEntity.peopleCount = 1
        
        let ownerEntity = PersonOwnerEntity(context: DatabaseController.persistentContainer.viewContext)
        ownerEntity.email = "testing email"
        ownerEntity.name = "testing name"
        
        entity.name = "testing name"
        entity.orgName = "testing org"
        entity.id = 123
        entity.primaryEmail = ""
        entity.ownerName = ""
        entity.orgName = ""
        entity.openDealsCount = 0
        entity.closedDealsCount = 0
        entity.wonDealsCount = 0
        entity.lostDealsCount = 0
        entity.activitiesCount = 0
        entity.doneActivitiesCount = 0
        entity.undoneActivitiesCount = 0
        entity.lastActivityDate = Date()
        entity.activeFlag = true
        
        entity.phone = NSSet(array: [phoneEntity])
        entity.orgId = orgEntity
        entity.ownerId = ownerEntity
        
        return entity
    }
}
