//
//  CountryParser.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import SwiftyJSON

class CountryParser: IParser {
    typealias Model = (AppWayByCountry)
    
    func parse(json: JSON) -> Model? {
        guard let tab = Int(json["data"]["tabs"].stringValue) else { return nil}
        return AppWayByCountry(tab: tab)
    }
}
