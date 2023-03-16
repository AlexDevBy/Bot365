//
//  CustomTabItem.swift
//  SuperBest
//
//  Created by Дмитрий Терехин on 04.10.2022.
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
            return UIImage(named: "SelectedHome")
        case .location:
            return UIImage(named: "SelectedMyLocation")
        case .calendar:
            return UIImage(named: "SelectedCalendar")
        case .settings:
            return UIImage(named: "SelectedUser")
        }
    }
}
