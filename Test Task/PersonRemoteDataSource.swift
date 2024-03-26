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
        var components = URLComponents(string: "https://api.pipedrive.com/v1/persons/")
        components?.queryItems = [
            URLQueryItem(name: "api_token", value: "52bfcd9a52ba512c2a71b4fec8fc2969e222a990")
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
            
            Task(priority: .background) {
                // saves data loaded to the device
                self.saveLocally(persons: decoded.data)
            }
            
            return .success(decoded.data)
            
        } catch(let e) {
            return .failure(.unexpected(description: e.localizedDescription))
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
