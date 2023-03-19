//
//  SportsObjectParser.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import SwiftyJSON

class SportObjectListParser: IParser {
    
    typealias Model = ([SportObjectListModel])
    
    func parse(json: JSON) -> Model? {
        let dataSource = json["features"].arrayValue
        return dataSource.map { object in
            SportObjectListModel(objectName: object["properties"]["formatted"].stringValue,
                                 address: object["properties"]["datasource"]["raw"]["name"].stringValue)
        }
    }

}
