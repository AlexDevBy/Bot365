//
//  LinkParser.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import SwiftyJSON

class LinkParser: IParser {
    typealias Model = String
    
    func parse(json: JSON) -> Model? {
        return json.arrayValue.first?["link"].stringValue
    }
}
