//
//  SucceedParser.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import SwiftyJSON

class SucceedParser: IParser {
    
    typealias Model = (Bool, String)
    
    func parse(json: JSON) -> Model? {
        return (json["data"]["premium"].boolValue, json["message"].stringValue)
    }

}
