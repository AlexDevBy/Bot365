//
//  LinkParser.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 29.11.2022.
//

import Foundation
import SwiftyJSON

class LinkParser: IParser {
    typealias Model = String
    
    func parse(json: JSON) -> Model? {
        return json.arrayValue.first?["link"].stringValue
    }
}
