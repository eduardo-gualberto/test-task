//
//  PersonRemoteDataSourceMock.swift
//  Test TaskTests
//
//  Created by Eduardo Gualberto on 26/03/24.
//

import Foundation
import CoreData
@testable import Test_Task

//enum PersonError: Error {
//    case unexpected(description: String)
//    case server(code: Int)
//    case parsingError
//    case noDataFetched
//    case localDBFail
//}

extension PersonError : Equatable {
    public static func == (lhs: PersonError, rhs: PersonError) -> Bool {
        switch (lhs, rhs) {
        case (.parsingError, .parsingError), (.noDataFetched, .noDataFetched), (.localDBFail, .localDBFail):
            return true
        case (.server(let lhsCode), .server(let rhsCode)):
            return lhsCode == rhsCode
        case (.unexpected(let lhsDesc), .unexpected(let rhsDesc)):
            return lhsDesc == rhsDesc
        default:
            return false
        }
        
    }
}

extension PersonModel: Equatable {
    public static func == (lhs: Test_Task.PersonModel, rhs: Test_Task.PersonModel) -> Bool {
        return true
    }
}

struct PersonRemoteDataSourceMock {
    func fetchAll(with url: String, token: String, save: Bool = false) async -> Result<[PersonModel], PersonError> {
        var components = URLComponents(string: url)
        components?.queryItems = [
            URLQueryItem(name: "api_token", value: token)
        ]
        guard let components = components, let url = components.url else {
            return .failure(.unexpected(description: "Couldn't find server"))
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let response = response as? HTTPURLResponse {
                if (400 ... 599).contains(response.statusCode) {
                    return .failure(.server(code: response.statusCode))
                }
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let decoded = try decoder.decode(RawPersonsResponse.self, from: data)
            
            if save {
                Task(priority: .background) {
                    // saves data loaded to the device
                    self.saveLocally(persons: decoded.data)
                }
            }
            
            return .success(decoded.data)
            
        } catch {
            return .failure(.parsingError)
        }
    }
    
    private func saveLocally(persons: [PersonModel]) {
        // Make it so the creation of entitys and saving process happens on the same queue
        DatabaseController.persistentContainer.viewContext.performAndWait {
            for person in persons {
                let _ = person.toEntity()
            }
            DatabaseController.saveContext()
        }
        
    }
}
