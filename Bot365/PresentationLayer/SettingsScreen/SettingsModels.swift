//
//  SettingsModels.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation

enum SettingType: CaseIterable {
    case myTrains
    case turnOffAdds
    case rateUs
    case feedback
    case privacy
    case terms
    case restorePurchases
    case deleteAccount
    
    var title: String {
        switch self {
        case .myTrains:
            return "Your reservations"
        case .turnOffAdds:
            return "Buy Premium"
        case .rateUs:
            return "Rate us"
        case .feedback:
            return "Support"
        case .privacy:
            return "Privacy policy"
        case .terms:
            return "Terms of use"
        case .restorePurchases:
            return "Restore purchase"
        case .deleteAccount:
            return "Delete account"
        }
    }
    
    var image: UIImage {
        switch self {
        case .myTrains:
            return UIImage(named: "premium")!
        case .turnOffAdds:
            return UIImage(named: "premium")!
        case .rateUs:
            return UIImage(named: "rate")!
        case .feedback:
            return UIImage(named: "support")!
        case .privacy:
            return UIImage(named: "privacy")!
        case .terms:
            return UIImage(named: "terms")!
        case .restorePurchases:
            return UIImage(named: "restore")!
        case .deleteAccount:
            return UIImage(named: "delete")!
        }
    }
    
    var imageArrow: UIImage {
        switch self {
        case .myTrains:
            return UIImage(named: "arrow")!
        case .turnOffAdds:
            return UIImage(named: "arrow")!
        case .rateUs:
            return UIImage(named: "arrow")!
        case .feedback:
            return UIImage(named: "arrow")!
        case .privacy:
            return UIImage(named: "arrow")!
        case .terms:
            return UIImage(named: "arrow")!
        case .restorePurchases:
            return UIImage(named: "arrow")!
        case .deleteAccount:
            return UIImage(named: "arrow")!
        }
    }
}
