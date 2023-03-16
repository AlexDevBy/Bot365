//
//  AppleRevokeTokenParser.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 29.11.2022.
//

import Foundation
import SwiftyJSON

class AppleRevokeTokenParser: IParser {
        
    typealias Model = Bool
    
    func parse(json: JSON) -> Model? {
        return true
    }
}
