//
//  CustomTabItem.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit

enum CustomTabItemType {
    case home
    case location
    case calendar
    case settings
}

struct CustomTabItem: Equatable {
    let type: CustomTabItemType
    let viewController: UIViewController
    
    var icon: UIImage? {
        type.icon
    }
    
    var selectedIcon: UIImage? {
        type.selectedIcon
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type
    }
}

extension CustomTabItemType {

    var icon: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "Home")
        case .location:
            return UIImage(named: "SelectedMyLocation")?.withRenderingMode(.alwaysTemplate).withTintColor(.gray)
        case .calendar:
            return UIImage(named: "Calendar")
        case .settings:
            return UIImage(named: "User")
        }
    }

    var selectedIcon: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "Home2")
        case .location:
            return UIImage(named: "SelectedMyLocation")
        case .calendar:
            return UIImage(named: "Calendar2")
        case .settings:
            return UIImage(named: "User2")
        }
    }
}
