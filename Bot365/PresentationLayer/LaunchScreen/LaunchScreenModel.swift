//
//  LaunchScreenModel.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation

enum AppWayByCountry {
    case toApp
    case web
    
    init(tab: Int) {
        switch tab {
        case 1:
            self = .toApp
        case 2:
            self = .web
        default:
            self = .web
        }
    }
}
