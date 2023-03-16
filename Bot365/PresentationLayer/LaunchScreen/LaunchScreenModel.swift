//
//  LaunchScreenModel.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 29.11.2022.
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
