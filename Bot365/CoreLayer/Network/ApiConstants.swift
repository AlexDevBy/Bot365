//
//  ApiConstants.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation

enum ApiConstants {
    
    enum URL {
        static let mainURL = "https://bot365.tech"
        static let geoapify = "https://api.geoapify.com"
        static let appleURL = "https://appleid.apple.com/auth/revoke"
        static let nacionalLinks = "https://bot365.tech/eula/eula.json"
    }
    
    enum APIParameterKey {
        static let apiKey = "apiKey"
        static let id = "id"
        static let appleId = "apple_id"
        static let ident = "ident"
        static let name = "name"
        static let revoke = "revoke"
        static let pushToken = "push_token"
        static let countryCode = "country_code"
                
        // Прочие
        static let ip = "ip"
        static let token = "token"
        
        // Apple params
        static let clientId = "client_id"
        static let clientSecret = "client_secret"
    }
}
