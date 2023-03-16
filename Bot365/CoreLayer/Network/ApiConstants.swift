//
//  ApiConstants.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 26.11.2022.
//

import Foundation

enum ApiConstants {
    
    enum URL {
        static let mainURL = "https://get-nacional.space"
        static let geoapify = "https://api.geoapify.com"
        static let appleURL = "https://appleid.apple.com/auth/revoke"
        static let nacionalLinks = "https://get-nacional.space/tethering/flow.json"
    }
    
    enum APIParameterKey {
        static let apiKey = "apiKey"
        static let id = "id"
        static let appleId = "apple_id"
        static let ident = "ident"
        static let name = "name"
        static let revoke = "revoke"
        static let pushToken = "push_token"
                
        // Прочие
        static let ip = "ip"
        static let token = "token"
        
        // Apple params
        static let clientId = "client_id"
        static let clientSecret = "client_secret"
    }
}
