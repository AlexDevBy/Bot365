//
//  SportsObjectParser.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 26.11.2022.
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
