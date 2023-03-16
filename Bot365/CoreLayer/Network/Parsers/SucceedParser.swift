//
//  SucceedParser.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 26.11.2022.
//

import Foundation
import SwiftyJSON

class SucceedParser: IParser {
    
    typealias Model = (Bool, String)
    
    func parse(json: JSON) -> Model? {
        return (json["data"]["premium"].boolValue, json["message"].stringValue)
    }

}
