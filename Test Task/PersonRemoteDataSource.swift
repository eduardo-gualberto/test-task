//
//  PersonRemoteRepository.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 21/03/24.
//

import Foundation

enum PersonError: Error {
    case unexpected(description: String)
    case server(code: Int)
    case parsingError
    case noDataFetched
}

struct RawPersonsResponse: Decodable {
    let success: Bool
    let data: [PersonModel]
}

struct PersonRemoteDataSource {
    func fetchAll(completion: @escaping (Result<[PersonModel], PersonError>) -> Void) {
        var components = URLComponents(string: "https://api.pipedrive.com/v1/persons/")
        components?.queryItems = [
            URLQueryItem(name: "api_token", value: "52bfcd9a52ba512c2a71b4fec8fc2969e222a990")
        ]
        guard let components = components, let url = components.url else {
            return completion(.failure(.unexpected(description: "Couldn't find server")))
        }
        
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                return completion(.failure(.unexpected(description: "Error creating dataTask")))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(.unexpected(description: "No response object")))
            }
            
            if (400 ... 599).contains(response.statusCode) {
                return completion(.failure(.server(code: response.statusCode)))
            }
            
            do {
                if let data = data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    let decoded = try decoder.decode(RawPersonsResponse.self, from: data)
                    
                    completion(.success(decoded.data))
                } else {
                    completion(.failure(.noDataFetched))
                }
            } catch(let e) {
                debugPrint(e)
                completion(.failure(.parsingError))
            }
        }
        dataTask.resume()
    }
}
