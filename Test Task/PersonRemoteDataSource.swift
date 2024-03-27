//
//  PersonRemoteRepository.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import Foundation
import CoreData

struct RawPersonsResponse: Decodable {
    let success: Bool
    let data: [PersonModel]
}

struct PersonRemoteDataSource {
    func fetchAll() async -> Result<[PersonModel], PersonError> {
        guard let url = Constants.personsApiURL else {
            return .failure(.unexpected(description: "Couldn't find server"))
        }
        guard let (data, response) = try? await makeApiCall(with: url) else {
            return .failure(.dataFetchingError)
        }
        if (400...599).contains(response.statusCode) {
            return .failure(.server(code: response.statusCode))
        }
        
        if let rawResponse = try? decode(data: data) {
            if !rawResponse.success {
                return .failure(.unexpected(description: "API request failed"))
            }
            let persons = rawResponse.data
            Task(priority: .background) {
                // saves data loaded to the device
                self.saveLocally(persons: persons)
            }
            return .success(persons)
        }
        
        return .failure(.parsingError)
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
    
    private func decode(data: Data) throws -> RawPersonsResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let decoded = try decoder.decode(RawPersonsResponse.self, from: data)
        
        return decoded
    }
    
    private func makeApiCall(with url: URL) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        return (data, response as! HTTPURLResponse)
    }
}
