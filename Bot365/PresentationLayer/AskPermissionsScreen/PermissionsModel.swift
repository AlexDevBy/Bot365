//
//  PermissionsModel.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation

enum PermissionsType {
    case push(appWay: AppWayByCountry, link: String?)
    case location
    
    var title: String {
        switch self {
        case .push:
            return "Enable push\nnotifications now"
        case .location:
            return "Location access"
        }
    }
    
    var skip: String {
        switch self {
        case .push:
            return "No, Thank you"
        case .location:
            return "Don’t allow"
        }
    }
    
    var image: UIImage {
        switch self {
        case .push:
            return UIImage(named: "pushIcon")!
        case .location:
            return UIImage(named: "locationIcon")!
        }
    }
    
    var secondTitle: String {
        switch self {
        case .push:
            return "Don’t miss out exclusive deals and new updates"
        case .location:
            return "We need your location access\nto find arenas close to you"
        }
    }
}
