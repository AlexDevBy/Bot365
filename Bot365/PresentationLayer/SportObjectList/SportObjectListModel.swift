//
//  SportObjectListModel.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation

enum SportObjectListViewState {
    case initial
    case locationExist
    case noLocation
    case error(String)
}

struct SportObjectListModel {
    let objectName: String
    let address: String
}

struct Address {
    let formatted: String
    let housenumber: String
    let city: String
    let street: String
}
