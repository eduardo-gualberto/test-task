//
//  Constants.swift
//  Test Task
//
//  Created by Eduardo Gualberto on 27/03/24.
//

import Foundation

struct Constants {
    static let apiToken = "52bfcd9a52ba512c2a71b4fec8fc2969e222a990"
    
    static var personsApiURL: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.pipedrive.com"
        components.path = "/v1/persons"
        components.queryItems = [
            URLQueryItem(name: "api_token", value: Constants.apiToken)
        ]
        return components.url
    }
}
