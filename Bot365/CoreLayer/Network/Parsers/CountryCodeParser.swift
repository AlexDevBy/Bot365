//
//  CountryCodeParser.swift
//  Bot365
//
//  Created by Alex Misko on 31.03.23.
//

import SwiftyJSON

class CountryCodeParser: IParser {
    typealias Model = (CountryCode)
    
    func parse(json: JSON) -> Model? {
        let code = String(json["data"]["country_code"].stringValue)
        
        return CountryCode(countryCode: code)
    }
}
