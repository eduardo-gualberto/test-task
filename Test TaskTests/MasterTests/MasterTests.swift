//
//  Master.swift
//  Test TaskTests
//
//  Created by Eduardo Gualberto on 26/03/24.
//

import XCTest
@testable import Test_Task

final class MasterTests: XCTestCase {

    let remoteMock = PersonRemoteDataSourceMock()
    let localMock = PersonLocalDataSourceMock()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRemoteUnauthorized() async throws {
        
        let result = await remoteMock.fetchAll(with: "https://api.pipedrive.com/v1/persons/", token: "", save: false)
        
        XCTAssertEqual(result, .failure(.server(code: 401)))
    }
    
    func testRemoteParsingErrorWithPurpose() async throws {
        
        let result = await remoteMock.fetchAll(with: "https://apipipedrivecom/v1/persons/", token: "asdsda", save: false)
        
        XCTAssertEqual(result, .failure(.parsingError))
    }
    
    func testRemoteSuccessOrParsingErrorWithoutPurpose() async throws {
        
        let result = await remoteMock.fetchAll(with: "https://api.pipedrive.com/v1/persons/", token: "52bfcd9a52ba512c2a71b4fec8fc2969e222a990")
        
        switch result {
        //if it fails its because of connection issues
        case .failure(let error):
            XCTAssertEqual(error, .parsingError)
        case .success(let persons):
            XCTAssertFalse(persons.isEmpty)
        }
    }
    
    func testLocalReturnEmptyOnFirstBoot() throws {
        localMock.dropDatabase()
        
        let result = localMock.fetchAll()
        
        switch result {
        case .success(let persons):
            XCTAssertEqual(persons.count, 0)
        case .failure(_):
            XCTAssertTrue(false)
        }
    }
    
    func testLocalReturnAfterRemoteCall() async throws {
        let remoteResults = try (await remoteMock.fetchAll(with: "https://api.pipedrive.com/v1/persons/", token: "52bfcd9a52ba512c2a71b4fec8fc2969e222a990", save: true)).get()
        
        let localResults = try localMock.fetchAll().get()
        
        XCTAssertEqual(remoteResults.count, localResults.count)
    }
    
    func testLocalDataOverwrite() async throws {
        let remoteResults = try (await remoteMock.fetchAll(with: "https://api.pipedrive.com/v1/persons/", token: "52bfcd9a52ba512c2a71b4fec8fc2969e222a990", save: true)).get()

        let o = remoteResults.first!
        let updatedObject = PersonModel(id: o.id, name: o.name, primaryEmail: o.primaryEmail, ownerName: o.ownerName, orgName: o.orgName, openDealsCount: o.openDealsCount, closedDealsCount: o.closedDealsCount + 1, wonDealsCount: o.wonDealsCount, lostDealsCount: o.lostDealsCount, activitiesCount: o.activitiesCount, doneActivitiesCount: o.doneActivitiesCount, undoneActivitiesCount: o.undoneActivitiesCount, lastActivityDate: o.lastActivityDate, activeFlag: o.activeFlag, phone: o.phone, orgId: o.orgId, ownerId: o.ownerId)!
        
        localMock.insertObject(person: updatedObject)
        
        let savedObject = try localMock.fetchAll().get().first { pm in
            pm.id == updatedObject.id
        }!
        
        // the local object should have the field 1 unit greater than the one fetched from the API
        XCTAssertGreaterThan(savedObject.closedDealsCount, o.closedDealsCount)
        
    }
}
