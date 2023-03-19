//
//  AppleAuthParser.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import SwiftyJSON

class AppleAuthParser: IParser {
    
    typealias Model = AuthModel
    
    func parse(json: JSON) -> Model? {
        guard let dataJson = json["data"].arrayValue.first else { return nil }
        return AuthModel(refreshToken: dataJson["refresh_token"].stringValue,
                         accessToken: dataJson["access_token"].stringValue,
                         idToken: dataJson["id_token"].stringValue,
                         expiresIn: dataJson["expires_in"].stringValue,
                         tokenType: dataJson["token_type"].stringValue)
    }
}

class AuthParser: IParser {
    
    typealias Model = String
    
    func parse(json: JSON) -> Model? {
        return json["data"]["token"].string
    }
}
