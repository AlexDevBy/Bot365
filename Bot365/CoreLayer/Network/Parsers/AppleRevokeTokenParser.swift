//
//  AppleRevokeTokenParser.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import SwiftyJSON

class AppleRevokeTokenParser: IParser {
        
    typealias Model = Bool
    
    func parse(json: JSON) -> Model? {
        return true
    }
}
